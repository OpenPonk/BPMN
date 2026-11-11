"
I provide executable example models and diagram setups for the OpenPonk BPMN editor. I demonstrate complete and valid business process scenarios containing pools, events, gateways, activities, sub-processes, data objects, annotations, and directional flows.
"
Class {
	#name : 'OPBPMNExamples',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Examples',
	#package : 'OpenPonk-BPMN',
	#tag : 'Examples'
}

{ #category : 'private' }
OPBPMNExamples class >> connectSequenceFlowChain: aNodeCollection [
	aNodeCollection overlappingPairsDo: [ :sourceNode :targetNode |
		| flow |
		flow := (OPBPMNFlowModel from: sourceNode to: targetNode)
			name: String empty;
			type: 'Normal';
			yourself.
		sourceNode addFlow: flow.
		targetNode addFlow: flow ]
]

{ #category : 'accessing' }
OPBPMNExamples class >> emptyModel [
	"Answers a newly initialized, empty BPMN process model."

	^ OPBPMNModel new
		name: 'New BPMN Model';
		yourself
]

{ #category : 'examples' }
OPBPMNExamples class >> exampleAllElementsAndTypes [
	"Answers a comprehensive BPMN model showcasing all node types, markers, event triggers, timer types, call activities, non-interrupting events, data objects, annotations, and flow types."

	| model externalPool mainPool laneActivitiesAndData laneStartAndGateways laneIntermediateEvents laneSubProcessesAndEnds activities callActivity dataObjects startEvents timerConfigs gateways intermediateEvents collapsedSubProcesses expandedSubProcesses endEvents flowDefault flowConditional msgFlow1 msgFlow2 |
	model := self emptyModel.
	model
		name: 'All BPMN Elements and Types';
		isExecutable: true.

	externalPool := OPBPMNPoolModel new
		name: 'External Participant (Black-Box Pool)';
		yourself.
	mainPool := OPBPMNPoolModel new
		name: 'Comprehensive BPMN Showcase';
		yourself.
	model
		add: externalPool;
		add: mainPool.

	laneActivitiesAndData := OPBPMNLaneModel new name: '1. Activities & Data'; yourself.
	laneStartAndGateways := OPBPMNLaneModel new name: '2. Start & Gateways'; yourself.
	laneIntermediateEvents := OPBPMNLaneModel new name: '3. Intermediate Events'; yourself.
	laneSubProcessesAndEnds := OPBPMNLaneModel new name: '4. SubProcesses & Ends'; yourself.
	mainPool
		addLane: laneActivitiesAndData;
		addLane: laneStartAndGateways;
		addLane: laneIntermediateEvents;
		addLane: laneSubProcessesAndEnds.

	activities := #( #None #Service #User #Manual #Send #Receive ) collect: [ :eachType |
		| activity |
		activity := OPBPMNActivityModel new
			name: 'Task: ' , eachType asString;
			type: eachType;
			isCallActivity: false;
			yourself.
		eachType = OPBPMNNodeType Service ifTrue: [
			activity
				executableAttribute: 'implementation';
				executableAttributeValue: '##WebService' ].
		laneActivitiesAndData add: activity.
		activity ].
	callActivity := OPBPMNActivityModel new
		name: 'Call Activity (User)';
		type: OPBPMNNodeType User;
		isCallActivity: true;
		yourself.
	laneActivitiesAndData add: callActivity.
	self connectSequenceFlowChain: activities , { callActivity }.

	dataObjects := #( #DataObject #DataInput #DataOutput #DataStore ) withIndexCollect: [ :eachDataType :index |
		| dataObj hostTask dataFlow |
		dataObj := OPBPMNDataObjectModel new
			name: eachDataType asString;
			type: eachDataType;
			yourself.
		laneActivitiesAndData add: dataObj.
		hostTask := activities at: index.
		dataFlow := eachDataType = OPBPMNNodeType DataOutput
			ifTrue: [ OPBPMNDataFlowModel from: hostTask to: dataObj ]
			ifFalse: [ OPBPMNDataFlowModel from: dataObj to: hostTask ].
		dataFlow name: String empty.
		dataObj addFlow: dataFlow.
		hostTask addFlow: dataFlow.
		dataObj ].

	#( #None #One #Both ) withIndexDo: [ :eachDirection :index |
		| note targetTask association |
		note := OPBPMNAnnotationModel new
			text: 'Annotation (' , eachDirection asString , ')';
			yourself.
		laneActivitiesAndData add: note.
		targetTask := activities at: index + 3.
		association := OPBPMNAssociationModel new
			source: note;
			target: targetTask;
			associationDirection: eachDirection;
			yourself.
		note addAssociation: association.
		targetTask addAssociation: association ].

	startEvents := OrderedCollection new.
	#( #None #Receive #Timer #Escalation #Conditional #Error #Compensation #Signal #Multiple #ParallelMultiple )
		withIndexDo: [ :eachStartType :index |
			| startEvent |
			startEvent := OPBPMNStartEventModel new
				name: eachStartType asString , (index even ifTrue: [ ' (Non-Int)' ] ifFalse: [ '' ]);
				type: eachStartType;
				isNonInterrupting: index even;
				yourself.
			eachStartType = OPBPMNNodeType Timer ifTrue: [
				startEvent
					timerType: #timeDuration;
					timerValue: 'PT15M' ].
			laneStartAndGateways add: startEvent.
			startEvents add: startEvent ].

	timerConfigs := {
		#none -> ''.
		#timeDate -> '2026-12-31T23:59:00Z'.
		#timeDuration -> 'PT4H'.
		#timeCycle -> 'R3/PT10M' }.

	gateways := #( #'Exclusive (empty)' #Exclusive #Inclusive #Parallel #Complex #Eventbased ) collect: [ :eachGwType |
		| gw |
		gw := OPBPMNGatewayModel new
			name: eachGwType asString;
			type: eachGwType;
			yourself.
		laneStartAndGateways add: gw.
		gw ].

	self connectSequenceFlowChain: startEvents asArray , gateways.
	flowDefault := (gateways first outgoing detect: [ :each | each isKindOf: OPBPMNFlowModel ]).
	flowDefault
		name: 'Default';
		type: 'Default'.
	flowConditional := (gateways second outgoing detect: [ :each | each isKindOf: OPBPMNFlowModel ]).
	flowConditional
		name: 'Conditional';
		type: 'Conditional'.

	intermediateEvents := #(
		#None #Send #Receive #Timer #Escalation #EscalationThrow
		#Conditional #Link #LinkThrow #Compensation #CompensationThrow
		#Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple )
		withIndexCollect: [ :eachIntType :index |
			| intEvent |
			intEvent := OPBPMNIntermediateEventModel new
				name: eachIntType asString;
				type: eachIntType;
				yourself.
			eachIntType = OPBPMNNodeType Timer ifTrue: [
				| cfg |
				cfg := timerConfigs at: ((index - 1) \\ timerConfigs size) + 1.
				intEvent
					timerType: cfg key;
					timerValue: cfg value ].
			laneIntermediateEvents add: intEvent.
			intEvent ].
	self connectSequenceFlowChain: intermediateEvents.

	collapsedSubProcesses := #( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation #MarkerAdhoc )
		withIndexCollect: [ :eachMarker :index |
			| collapsed |
			collapsed := OPBPMNCollapsedSubProcessModel new
				name: eachMarker asString;
				type: eachMarker;
				isCallActivity: index even;
				yourself.
			laneSubProcessesAndEnds add: collapsed.
			collapsed ].

	expandedSubProcesses := #( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation #MarkerAdhoc )
		collect: [ :eachMarker |
			| expanded innerStart innerEnd innerFlow |
			expanded := OPBPMNSubProcessModel new
				name: 'Sub: ' , eachMarker asString;
				type: eachMarker;
				yourself.
			innerStart := OPBPMNStartEventModel new
				name: 'In';
				type: OPBPMNNodeType None;
				yourself.
			innerEnd := OPBPMNEndEventModel new
				name: 'Out';
				type: OPBPMNNodeType None;
				yourself.
			innerFlow := (OPBPMNFlowModel from: innerStart to: innerEnd)
				name: String empty;
				type: 'Normal';
				yourself.
			innerStart addFlow: innerFlow.
			innerEnd addFlow: innerFlow.
			expanded
				add: innerStart;
				add: innerEnd.
			laneSubProcessesAndEnds add: expanded.
			expanded ].

	#( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation #Signal #Multiple #ParallelMultiple )
		withIndexDo: [ :eachBoundaryType :index |
			| hostNode boundaryEvent cfg |
			hostNode := index <= 6
				ifTrue: [ collapsedSubProcesses at: index ]
				ifFalse: [ expandedSubProcesses at: index - 6 ].
			boundaryEvent := OPBPMNBoundaryEventModel new
				name: eachBoundaryType asString;
				type: eachBoundaryType;
				isNonInterrupting: index even;
				yourself.
			eachBoundaryType = OPBPMNNodeType Timer ifTrue: [
				cfg := timerConfigs last.
				boundaryEvent
					timerType: cfg key;
					timerValue: cfg value ].
			hostNode add: boundaryEvent ].

	endEvents := #( #None #Send #EscalationThrow #Error #Cancel #CompensationThrow #SignalThrow #MultipleThrow #Terminate )
		collect: [ :eachEndType |
			| endEvent |
			endEvent := OPBPMNEndEventModel new
				name: eachEndType asString;
				type: eachEndType;
				yourself.
			laneSubProcessesAndEnds add: endEvent.
			endEvent ].

	self connectSequenceFlowChain: collapsedSubProcesses , expandedSubProcesses , endEvents.

	msgFlow1 := (OPBPMNMessageFlowModel from: externalPool to: startEvents second)
		name: 'Inbound Msg';
		yourself.
	externalPool addFlow: msgFlow1.
	startEvents second addFlow: msgFlow1.

	msgFlow2 := (OPBPMNMessageFlowModel from: activities fifth to: externalPool)
		name: 'Outbound Msg';
		yourself.
	activities fifth addFlow: msgFlow2.
	externalPool addFlow: msgFlow2.

	^ model
]

{ #category : 'examples' }
OPBPMNExamples class >> exampleOrderFulfillment [
	| model poolCustomer poolVendor laneSales laneWarehouse startEvent taskCheckStock gatewayInStock procureSubProcess subStart taskOrderSupplier subEnd flowSubStartToTask flowTaskToSubEnd boundaryTimer gatewayReadyToShip collapsedSubProcess intermediateTimer endEventFulfilled endEventCanceled dataObjectOrder annotationSla flowStartToTask flowTaskToGateway flowGatewayToProcure flowGatewayToMerge flowProcureToMerge flowMergeToShip flowBoundaryToCancel flowShipToIntermediate flowIntermediateToEnd messageFlow dataFlow association |
	model := self emptyModel.
	model name: 'Order Fulfillment'.
	poolCustomer := OPBPMNPoolModel new
		name: 'Customer';
		yourself.
	poolVendor := OPBPMNPoolModel new
		name: 'Order Fulfillment';
		yourself.
	model
		add: poolCustomer;
		add: poolVendor.

	laneSales := OPBPMNLaneModel new
		name: 'Sales';
		yourself.
	laneWarehouse := OPBPMNLaneModel new
		name: 'Warehouse';
		yourself.
	poolVendor
		addLane: laneSales;
		addLane: laneWarehouse.

	startEvent := OPBPMNStartEventModel new
		name: 'Order Placed';
		type: OPBPMNNodeType Receive;
		yourself.
	taskCheckStock := OPBPMNActivityModel new
		name: 'Check Stock';
		type: OPBPMNNodeType User;
		yourself.
	gatewayInStock := OPBPMNGatewayModel new
		name: 'In Stock?';
		type: OPBPMNNodeType Exclusive;
		yourself.
	procureSubProcess := OPBPMNSubProcessModel new
		name: 'Procure Items';
		yourself.
	subStart := OPBPMNStartEventModel new
		name: String empty;
		type: OPBPMNNodeType None;
		yourself.
	taskOrderSupplier := OPBPMNActivityModel new
		name: 'Order from Vendor';
		type: OPBPMNNodeType Service;
		executableAttribute: 'vendorApi';
		executableAttributeValue: 'postPurchaseOrder';
		yourself.
	subEnd := OPBPMNEndEventModel new
		name: 'Vendor Ordered';
		type: OPBPMNNodeType None;
		yourself.
	flowSubStartToTask := (OPBPMNFlowModel from: subStart to: taskOrderSupplier)
		name: String empty;
		type: 'Normal';
		yourself.
	subStart addFlow: flowSubStartToTask.
	taskOrderSupplier addFlow: flowSubStartToTask.
	flowTaskToSubEnd := (OPBPMNFlowModel from: taskOrderSupplier to: subEnd)
		name: String empty;
		type: 'Normal';
		yourself.
	taskOrderSupplier addFlow: flowTaskToSubEnd.
	subEnd addFlow: flowTaskToSubEnd.
	procureSubProcess
		add: subStart;
		add: taskOrderSupplier;
		add: subEnd.
	boundaryTimer := OPBPMNBoundaryEventModel new
		name: '2 Days SLA';
		type: OPBPMNNodeType Timer;
		isNonInterrupting: false;
		yourself.
	procureSubProcess add: boundaryTimer.
	gatewayReadyToShip := OPBPMNGatewayModel new
		name: String empty;
		type: OPBPMNNodeType Exclusive;
		yourself.
	collapsedSubProcess := OPBPMNCollapsedSubProcessModel new
		name: 'Prepare Shipment';
		type: OPBPMNNodeType None;
		yourself.
	intermediateTimer := OPBPMNIntermediateEventModel new
		name: 'Wait for Carrier';
		type: OPBPMNNodeType Timer;
		timerType: #timeDuration;
		timerValue: 'PT2H';
		yourself.
	endEventFulfilled := OPBPMNEndEventModel new
		name: 'Order Delivered';
		type: OPBPMNNodeType None;
		yourself.
	endEventCanceled := OPBPMNEndEventModel new
		name: 'Order Canceled';
		type: OPBPMNNodeType Error;
		yourself.
	dataObjectOrder := OPBPMNDataObjectModel new
		name: 'Order Details';
		type: OPBPMNNodeType DataObject;
		yourself.
	annotationSla := OPBPMNAnnotationModel new
		text: 'Standard fulfillment SLA: 48 hours';
		yourself.

	laneSales
		add: startEvent;
		add: taskCheckStock;
		add: gatewayInStock;
		add: procureSubProcess;
		add: endEventCanceled;
		add: dataObjectOrder;
		add: annotationSla.

	laneWarehouse
		add: gatewayReadyToShip;
		add: collapsedSubProcess;
		add: intermediateTimer;
		add: endEventFulfilled.

	flowStartToTask := (OPBPMNFlowModel from: startEvent to: taskCheckStock)
		name: String empty;
		type: 'Normal';
		yourself.
	startEvent addFlow: flowStartToTask.
	taskCheckStock addFlow: flowStartToTask.
	flowTaskToGateway := (OPBPMNFlowModel from: taskCheckStock to: gatewayInStock)
		name: String empty;
		type: 'Normal';
		yourself.
	taskCheckStock addFlow: flowTaskToGateway.
	gatewayInStock addFlow: flowTaskToGateway.
	flowGatewayToProcure := (OPBPMNFlowModel from: gatewayInStock to: procureSubProcess)
		name: 'Out of Stock';
		type: 'Normal';
		yourself.
	gatewayInStock addFlow: flowGatewayToProcure.
	procureSubProcess addFlow: flowGatewayToProcure.
	flowGatewayToMerge := (OPBPMNFlowModel from: gatewayInStock to: gatewayReadyToShip)
		name: 'In Stock';
		type: 'Default';
		yourself.
	gatewayInStock addFlow: flowGatewayToMerge.
	gatewayReadyToShip addFlow: flowGatewayToMerge.
	flowProcureToMerge := (OPBPMNFlowModel from: procureSubProcess to: gatewayReadyToShip)
		name: 'Procured';
		type: 'Normal';
		yourself.
	procureSubProcess addFlow: flowProcureToMerge.
	gatewayReadyToShip addFlow: flowProcureToMerge.
	flowMergeToShip := (OPBPMNFlowModel from: gatewayReadyToShip to: collapsedSubProcess)
		name: String empty;
		type: 'Normal';
		yourself.
	gatewayReadyToShip addFlow: flowMergeToShip.
	collapsedSubProcess addFlow: flowMergeToShip.
	flowBoundaryToCancel := (OPBPMNFlowModel from: boundaryTimer to: endEventCanceled)
		name: 'SLA Breach';
		type: 'Normal';
		yourself.
	boundaryTimer addFlow: flowBoundaryToCancel.
	endEventCanceled addFlow: flowBoundaryToCancel.
	flowShipToIntermediate := (OPBPMNFlowModel from: collapsedSubProcess to: intermediateTimer)
		name: String empty;
		type: 'Normal';
		yourself.
	collapsedSubProcess addFlow: flowShipToIntermediate.
	intermediateTimer addFlow: flowShipToIntermediate.
	flowIntermediateToEnd := (OPBPMNFlowModel from: intermediateTimer to: endEventFulfilled)
		name: String empty;
		type: 'Normal';
		yourself.
	intermediateTimer addFlow: flowIntermediateToEnd.
	endEventFulfilled addFlow: flowIntermediateToEnd.
	messageFlow := (OPBPMNMessageFlowModel from: poolCustomer to: startEvent)
		name: 'Place Order';
		yourself.
	poolCustomer addFlow: messageFlow.
	startEvent addFlow: messageFlow.
	dataFlow := (OPBPMNDataFlowModel from: dataObjectOrder to: taskCheckStock)
		name: 'Order Info';
		yourself.
	dataObjectOrder addFlow: dataFlow.
	taskCheckStock addFlow: dataFlow.
	association := OPBPMNAssociationModel new
		source: annotationSla;
		target: taskCheckStock;
		associationDirection: OPBPMNAssociationModel associationDirectionNone;
		yourself.
	annotationSla addAssociation: association.
	taskCheckStock addAssociation: association.
	^ model
]

{ #category : 'opening' }
OPBPMNExamples class >> openExample: aModel [
	"Opens the given BPMN model in a newly created OpenPonk workbench and lays out all elements, guaranteeing window closure on failure."

	| project newWorkbench |
	project := OPProject named: 'BPMN Example'.
	project addModel: aModel.
	newWorkbench := OPWorkbench openProject: project.
	[ newWorkbench showAllElementsInAllDiagrams ]
		ifCurtailed: [ newWorkbench close ].
	^ newWorkbench
]

{ #category : 'examples' }
OPBPMNExamples class >> openExampleAllElementsAndTypes [
	"Creates and opens the comprehensive BPMN showcase containing all node types, markers, and properties."

	<example>
	^ self openExample: self exampleAllElementsAndTypes
]

{ #category : 'examples' }
OPBPMNExamples class >> openExampleEmptyModel [
	"Creates and opens an empty BPMN diagram in workbench."

	<example>
	^ self openExample: self emptyModel
]

{ #category : 'examples' }
OPBPMNExamples class >> openExampleOrderFulfillment [
	"Creates and opens the comprehensive Order Fulfillment BPMN example in workbench."

	<example>
	^ self openExample: self exampleOrderFulfillment
]
