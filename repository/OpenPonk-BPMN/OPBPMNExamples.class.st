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

{ #category : 'accessing' }
OPBPMNExamples class >> emptyModel [
	"Answers a newly initialized, empty BPMN process model."

	^ OPBPMNModel new
		name: 'New BPMN Model';
		yourself
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
