"
Verifies connection and containment targeting rules for BPMN diagram controllers, ensuring compliance with containment hierarchy, sequence flows, message flows, data associations, and annotations.
"
Class {
	#name : 'OPBPMNConnectionAndTargetingRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'model',
		'diagram',
		'projectController',
		'diagramController',
		'undoManager'
	],
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNConnectionAndTargetingRulesTest >> setUp [
	super setUp.
	project := OPProject new.
	model := OPBPMNModel new.
	project addModel: model.
	diagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: diagram.
	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself);
		diagramElement: diagram;
		model: model.
	diagramController showAllElements
]

{ #category : 'running' }
OPBPMNConnectionAndTargetingRulesTest >> tearDown [
	diagramController := nil.
	diagram := nil.
	projectController := nil.
	project := nil.
	model := nil.
	undoManager := nil.
	super tearDown
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testActivityCanBeTargetForBoundaryEvent [
	| activityModel activityController boundaryEventController |
	activityModel := OPBPMNActivityModel new.
	activityController := diagramController newControllerFor: activityModel.
	boundaryEventController := OPBPMNBoundaryEventController new.
	boundaryEventController diagramController: diagramController.
	self
		assert: (activityController canBeTargetFor: boundaryEventController)
		description: 'Activity controller must accept boundary event controller as target'
]

{ #category : 'tests - association' }
OPBPMNConnectionAndTargetingRulesTest >> testAssociationCannotConnectActivityAndGateway [
	| task gateway taskController gatewayController assocController |
	task := OPBPMNActivityModel new.
	gateway := OPBPMNGatewayModel new.
	model add: task; add: gateway.
	taskController := diagramController newControllerFor: task.
	gatewayController := diagramController newControllerFor: gateway.
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: taskController.
	self
		deny: (gatewayController canBeTargetFor: assocController)
		description: 'Association must not connect an activity and a gateway'
]

{ #category : 'tests - association' }
OPBPMNConnectionAndTargetingRulesTest >> testAssociationCannotConnectTwoActivities [
	| task1 task2 task1Controller task2Controller assocController |
	task1 := OPBPMNActivityModel new.
	task2 := OPBPMNActivityModel new.
	model add: task1; add: task2.
	task1Controller := diagramController newControllerFor: task1.
	task2Controller := diagramController newControllerFor: task2.
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: task1Controller.
	self
		deny: (task2Controller canBeTargetFor: assocController)
		description: 'Association must not connect two activities without an annotation'
]

{ #category : 'tests - association' }
OPBPMNConnectionAndTargetingRulesTest >> testAssociationCannotConnectTwoAnnotations [
	| annotation1 annotation2 annotation1Controller annotation2Controller assocController |
	annotation1 := OPBPMNAnnotationModel new.
	annotation2 := OPBPMNAnnotationModel new.
	model add: annotation1; add: annotation2.
	annotation1Controller := diagramController newControllerFor: annotation1.
	annotation2Controller := diagramController newControllerFor: annotation2.
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: annotation1Controller.
	self
		deny: (annotation2Controller canBeTargetFor: assocController)
		description: 'Association must not connect two annotations together'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testCollapsedSubProcessCanBeTargetForBoundaryEvent [
	| collapsedModel collapsedController boundaryEventController |
	collapsedModel := OPBPMNCollapsedSubProcessModel new.
	collapsedController := diagramController newControllerFor: collapsedModel.
	boundaryEventController := OPBPMNBoundaryEventController new.
	boundaryEventController diagramController: diagramController.
	self
		assert: (collapsedController canBeTargetFor: boundaryEventController)
		description: 'Collapsed subprocess controller must accept boundary event controller as target'
]

{ #category : 'tests - association' }
OPBPMNConnectionAndTargetingRulesTest >> testCompensationAssociationCannotCrossPoolOrSubProcessBoundaries [
	| pool1 pool2 subProcess taskInPool1 boundaryOnTask1 taskInPool2 taskInSubProcess boundaryController taskInPool2Controller taskInSubController assocController |
	pool1 := OPBPMNPoolModel new name: 'Pool 1'.
	pool2 := OPBPMNPoolModel new name: 'Pool 2'.
	taskInPool1 := OPBPMNActivityModel new name: 'Task 1'.
	boundaryOnTask1 := OPBPMNBoundaryEventModel new
		name: 'Comp';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	taskInPool1 add: boundaryOnTask1.
	subProcess := OPBPMNSubProcessModel new name: 'Sub'.
	taskInSubProcess := OPBPMNActivityModel new name: 'Inner Task'.
	subProcess add: taskInSubProcess.
	pool1 add: taskInPool1; add: subProcess.
	taskInPool2 := OPBPMNActivityModel new name: 'Task 2'.
	pool2 add: taskInPool2.
	model add: pool1; add: pool2.

	boundaryController := diagramController newControllerFor: boundaryOnTask1.
	taskInPool2Controller := diagramController newControllerFor: taskInPool2.
	taskInSubController := diagramController newControllerFor: taskInSubProcess.

	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: boundaryController.

	self
		deny: (taskInPool2Controller canBeTargetFor: assocController)
		description: 'Compensation association must not cross pool boundaries'.
	self
		deny: (taskInSubController canBeTargetFor: assocController)
		description: 'Compensation association must not cross subprocess boundaries'
]

{ #category : 'tests - association' }
OPBPMNConnectionAndTargetingRulesTest >> testCompensationBoundaryEventCanConnectViaAssociationToActivity [
	| task boundaryEvent compTask boundaryController compTaskController assocController |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		name: 'CompCatch';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	task add: boundaryEvent.
	compTask := OPBPMNActivityModel new name: 'CompHandler'.
	model add: task; add: compTask.
	boundaryController := diagramController newControllerFor: boundaryEvent.
	compTaskController := diagramController newControllerFor: compTask.
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: boundaryController.
	self
		assert: (compTaskController canBeTargetFor: assocController)
		description: 'Compensation boundary event must be allowed to connect via association to compensation activity'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testCompensationBoundaryEventCannotBeSourceForSequenceFlow [
	| task boundaryEvent boundaryController targetTask targetTaskController flowController |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		name: 'CompCatch';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	task add: boundaryEvent.
	targetTask := OPBPMNActivityModel new name: 'TargetTask'.
	model add: task; add: targetTask.
	boundaryController := diagramController newControllerFor: boundaryEvent.
	targetTaskController := diagramController newControllerFor: targetTask.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	self
		deny: (boundaryController canBeSourceFor: flowController)
		description: 'Compensation boundary event must not be allowed as source for sequence flow'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowAndMessageFlowRejectInvalidTargetsInCanConnectSourceToTarget [
	| pool1 pool2 dataObject gateway endEvent dataObjectController gatewayController pool1Controller endEventController dataFlowController msgFlowController |
	pool1 := OPBPMNPoolModel new name: 'BlackBox Pool'.
	pool2 := OPBPMNPoolModel new name: 'WhiteBox Pool'.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	gateway := OPBPMNGatewayModel new name: 'GW'.
	endEvent := OPBPMNEndEventModel new name: 'End'.
	pool2 add: dataObject; add: gateway; add: endEvent.
	model add: pool1; add: pool2.

	dataObjectController := diagramController newControllerFor: dataObject.
	gatewayController := diagramController newControllerFor: gateway.
	pool1Controller := diagramController newControllerFor: pool1.
	endEventController := diagramController newControllerFor: endEvent.

	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	self
		deny: (dataFlowController canConnectSource: dataObjectController toTarget: gatewayController)
		description: 'DataFlow canConnectSource:toTarget: must reject gateway as target'.
	self
		deny: (dataFlowController canConnectSource: dataObjectController toTarget: pool1Controller)
		description: 'DataFlow canConnectSource:toTarget: must reject pool as target'.

	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	self
		deny: (msgFlowController canConnectSource: pool1Controller toTarget: gatewayController)
		description: 'MessageFlow canConnectSource:toTarget: must reject gateway as target'.
	self
		deny: (msgFlowController canConnectSource: pool1Controller toTarget: endEventController)
		description: 'MessageFlow canConnectSource:toTarget: must reject end event as target'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowCanBeSourcedByBoundaryEvent [
	| boundaryEvent boundaryEventController dataFlowController |
	boundaryEvent := OPBPMNBoundaryEventModel new.
	boundaryEventController := diagramController newControllerFor: boundaryEvent.
	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	self
		assert: (boundaryEventController canBeSourceFor: dataFlowController)
		description: 'Boundary event controller must be allowed as source for data flow'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowCannotConnectTwoDataObjects [
	| data1 data2 data1Controller data2Controller dataFlowController |
	data1 := OPBPMNDataObjectModel new.
	data2 := OPBPMNDataObjectModel new.
	model add: data1; add: data2.
	data1Controller := diagramController newControllerFor: data1.
	data2Controller := diagramController newControllerFor: data2.
	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	dataFlowController source: data1Controller.
	self
		deny: (data2Controller canBeTargetFor: dataFlowController)
		description: 'Data flow must not connect two data objects directly'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowCannotCrossPoolBoundaries [
	| pool1 pool2 dataObject task dataObjectController taskController dataFlowController |
	pool1 := OPBPMNPoolModel new name: 'Pool 1'.
	pool2 := OPBPMNPoolModel new name: 'Pool 2'.
	dataObject := OPBPMNDataObjectModel new name: 'Data in Pool 1'.
	task := OPBPMNActivityModel new name: 'Task in Pool 2'.
	pool1 add: dataObject.
	pool2 add: task.
	model add: pool1; add: pool2.
	dataObjectController := diagramController newControllerFor: dataObject.
	taskController := diagramController newControllerFor: task.
	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	dataFlowController source: dataObjectController.
	self
		deny: (taskController canBeTargetFor: dataFlowController)
		description: 'Data flow must not connect elements across different pools'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowCannotTargetBoundaryEvent [
	| task boundaryEvent dataObject dataObjectController boundaryController dataFlowController |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'Boundary'.
	task add: boundaryEvent.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	model add: task; add: dataObject.
	dataObjectController := diagramController newControllerFor: dataObject.
	boundaryController := diagramController newControllerFor: boundaryEvent.
	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	dataFlowController source: dataObjectController.
	self
		deny: (boundaryController canBeTargetFor: dataFlowController)
		description: 'Data flow must not target a boundary event'
]

{ #category : 'tests - data flow' }
OPBPMNConnectionAndTargetingRulesTest >> testDataFlowCannotTargetStartEvent [
	| data1 startEvent data1Controller startEventController dataFlowController |
	data1 := OPBPMNDataObjectModel new.
	startEvent := OPBPMNStartEventModel new.
	model add: data1; add: startEvent.
	data1Controller := diagramController newControllerFor: data1.
	startEventController := diagramController newControllerFor: startEvent.
	dataFlowController := OPBPMNDataFlowController new.
	dataFlowController diagramController: diagramController.
	dataFlowController source: data1Controller.
	self
		deny: (startEventController canBeTargetFor: dataFlowController)
		description: 'Data flow must not target a start event'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testDiagramCannotBeTargetForBoundaryEvent [
	| boundaryEventController |
	boundaryEventController := OPBPMNBoundaryEventController new.
	boundaryEventController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: boundaryEventController)
		description: 'Diagram controller must not accept boundary event controller directly on canvas'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testDiagramCannotBeTargetForDataObjectWhenDiagramHasPool [
	| poolModel poolController dataObjectController |
	poolModel := OPBPMNPoolModel new.
	model add: poolModel.
	poolController := diagramController newControllerFor: poolModel.
	diagramController addController: poolController.
	dataObjectController := OPBPMNDataObjectController new.
	dataObjectController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: dataObjectController)
		description: 'Diagram controller must not accept data object at root when a pool is present'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testDiagramCannotBeTargetForLane [
	| laneController |
	laneController := OPBPMNLaneController new.
	laneController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: laneController)
		description: 'Diagram controller must not accept lane controller outside of a pool'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testDiagramCannotBeTargetForPoolOrActivityWhenCounterpartIsHiddenInModel [
	| hiddenPool activityController poolController |
	hiddenPool := OPBPMNPoolModel new name: 'Hidden Pool'.
	model add: hiddenPool.
	activityController := OPBPMNActivityController new.
	activityController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: activityController)
		description: 'Diagram controller must not accept activity at root when model already contains a pool (even if hidden)'.

	model remove: hiddenPool.
	model add: (OPBPMNActivityModel new name: 'Hidden Task').
	poolController := OPBPMNPoolController new.
	poolController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: poolController)
		description: 'Diagram controller must not accept pool when model already contains a root activity (even if hidden)'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testDiagramCannotBeTargetForPoolWhenDiagramHasRootElements [
	| task taskController poolController |
	task := OPBPMNActivityModel new name: 'TaskAtRoot'.
	model add: task.
	taskController := diagramController newControllerFor: task.
	diagramController addController: taskController.
	poolController := OPBPMNPoolController new.
	poolController diagramController: diagramController.
	self
		deny: (diagramController canBeTargetFor: poolController)
		description: 'Diagram controller must not accept pool when root diagram already contains process elements'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testLaneCannotBeTargetForBoundaryEvent [
	| laneModel laneController boundaryEventController |
	laneModel := OPBPMNLaneModel new.
	laneController := diagramController newControllerFor: laneModel.
	boundaryEventController := OPBPMNBoundaryEventController new.
	boundaryEventController diagramController: diagramController.
	self
		deny: (laneController canBeTargetFor: boundaryEventController)
		description: 'Lane controller must not accept boundary event controller directly'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testLaneCannotBeTargetForPool [
	| laneModel laneController poolController |
	laneModel := OPBPMNLaneModel new.
	laneController := diagramController newControllerFor: laneModel.
	poolController := OPBPMNPoolController new.
	poolController diagramController: diagramController.
	self
		deny: (laneController canBeTargetFor: poolController)
		description: 'Lane controller must not accept pool controller inside a lane'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testLinkEventsSequenceFlowTargetingRules [
	| task catchLink throwLink taskController catchLinkController throwLinkController flowController |
	task := OPBPMNActivityModel new name: 'Task'.
	catchLink := OPBPMNIntermediateEventModel new
		name: 'CatchLink';
		type: OPBPMNNodeType Link;
		yourself.
	throwLink := OPBPMNIntermediateEventModel new
		name: 'ThrowLink';
		type: OPBPMNNodeType LinkThrow;
		yourself.
	model add: task; add: catchLink; add: throwLink.
	taskController := diagramController newControllerFor: task.
	catchLinkController := diagramController newControllerFor: catchLink.
	throwLinkController := diagramController newControllerFor: throwLink.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: taskController.
	self
		deny: (catchLinkController canBeTargetFor: flowController)
		description: 'Catch link intermediate event must not accept incoming sequence flow'.
	flowController source: throwLinkController.
	self
		deny: (taskController canBeTargetFor: flowController)
		description: 'Throw link intermediate event must not have outgoing sequence flow'
]

{ #category : 'tests - message flow' }
OPBPMNConnectionAndTargetingRulesTest >> testMessageFlowCannotBeSourcedByWhiteBoxPool [
	| whiteBoxPool whiteBoxController msgFlowController |
	whiteBoxPool := OPBPMNPoolModel new name: 'White Box'.
	whiteBoxPool add: (OPBPMNActivityModel new name: 'Task').
	model add: whiteBoxPool.
	whiteBoxController := diagramController newControllerFor: whiteBoxPool.
	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	self
		deny: (whiteBoxController canBeSourceFor: msgFlowController)
		description: 'White-box pool containing elements must not be source for message flow'
]

{ #category : 'tests - message flow' }
OPBPMNConnectionAndTargetingRulesTest >> testMessageFlowCannotTargetActivityInRootDiagramFromPool [
	| pool taskInPool taskInRoot taskInPoolController taskInRootController msgFlowController |
	pool := OPBPMNPoolModel new name: 'Pool'.
	taskInPool := OPBPMNActivityModel new name: 'Task In Pool'.
	taskInRoot := OPBPMNActivityModel new name: 'Task In Root'.
	pool add: taskInPool.
	model add: pool; add: taskInRoot.
	taskInPoolController := diagramController newControllerFor: taskInPool.
	taskInRootController := diagramController newControllerFor: taskInRoot.
	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	msgFlowController source: taskInPoolController.
	self
		deny: (taskInRootController canBeTargetFor: msgFlowController)
		description: 'Message flow must not connect a pool element with an element in the root diagram'
]

{ #category : 'tests - message flow' }
OPBPMNConnectionAndTargetingRulesTest >> testMessageFlowCannotTargetEndEvent [
	| blackBoxPool whiteBoxPool endEvent blackBoxController endEventController msgFlowController |
	blackBoxPool := OPBPMNPoolModel new name: 'SenderPool'.
	whiteBoxPool := OPBPMNPoolModel new name: 'ReceiverPool'.
	endEvent := OPBPMNEndEventModel new name: 'End'.
	whiteBoxPool add: endEvent.
	model add: blackBoxPool; add: whiteBoxPool.
	blackBoxController := diagramController newControllerFor: blackBoxPool.
	endEventController := diagramController newControllerFor: endEvent.
	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	msgFlowController source: blackBoxController.
	self
		deny: (endEventController canBeTargetFor: msgFlowController)
		description: 'Message flow must not target an end event'
]

{ #category : 'tests - message flow' }
OPBPMNConnectionAndTargetingRulesTest >> testMessageFlowCannotTargetOrSourceDataObject [
	| blackBoxPool whiteBoxPool dataObject blackBoxController dataObjectController msgFlowController |
	blackBoxPool := OPBPMNPoolModel new name: 'BlackBox'.
	whiteBoxPool := OPBPMNPoolModel new name: 'WhiteBox'.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	whiteBoxPool add: dataObject.
	model add: blackBoxPool; add: whiteBoxPool.
	blackBoxController := diagramController newControllerFor: blackBoxPool.
	dataObjectController := diagramController newControllerFor: dataObject.
	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	msgFlowController source: blackBoxController.
	self
		deny: (dataObjectController canBeTargetFor: msgFlowController)
		description: 'Message flow must not target a data object'.
	msgFlowController source: dataObjectController.
	self
		deny: (blackBoxController canBeTargetFor: msgFlowController)
		description: 'Message flow must not be sourced by a data object'
]

{ #category : 'tests - message flow' }
OPBPMNConnectionAndTargetingRulesTest >> testMessageFlowCannotTargetWhiteBoxPool [
	| whiteBoxPool blackBoxPool whiteBoxController blackBoxController msgFlowController |
	whiteBoxPool := OPBPMNPoolModel new name: 'White Box'.
	whiteBoxPool add: (OPBPMNActivityModel new name: 'Task').
	blackBoxPool := OPBPMNPoolModel new name: 'Black Box'.
	model add: whiteBoxPool; add: blackBoxPool.
	whiteBoxController := diagramController newControllerFor: whiteBoxPool.
	blackBoxController := diagramController newControllerFor: blackBoxPool.
	msgFlowController := OPBPMNMessageFlowController new.
	msgFlowController diagramController: diagramController.
	msgFlowController source: blackBoxController.
	self
		deny: (whiteBoxController canBeTargetFor: msgFlowController)
		description: 'Message flow must not target the boundary of a white-box pool containing elements'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testPoolCanBeTargetForLaneWhenPoolHasElements [
	| pool task poolController laneController |
	pool := OPBPMNPoolModel new name: 'PoolWithTask'.
	task := OPBPMNActivityModel new name: 'InitialTask'.
	pool add: task.
	model add: pool.
	poolController := diagramController newControllerFor: pool.
	laneController := OPBPMNLaneController new.
	laneController diagramController: diagramController.
	self
		assert: (poolController canBeTargetFor: laneController)
		description: 'Pool containing elements must accept lane controller as target so elements can be migrated into first lane'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testPoolCannotBeTargetForBoundaryEvent [
	| poolModel poolController boundaryEventController |
	poolModel := OPBPMNPoolModel new.
	poolController := diagramController newControllerFor: poolModel.
	boundaryEventController := OPBPMNBoundaryEventController new.
	boundaryEventController diagramController: diagramController.
	self
		deny: (poolController canBeTargetFor: boundaryEventController)
		description: 'Pool controller must not accept boundary event controller directly'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testSequenceFlowCanBeSourcedByBoundaryEventOnSubProcessToOuterNode [
	| subProcess boundaryEvent outerTask boundaryController outerTaskController flowController |
	subProcess := OPBPMNSubProcessModel new name: 'SubProcess'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'BoundaryEvent'.
	outerTask := OPBPMNActivityModel new name: 'OuterTask'.
	subProcess add: boundaryEvent.
	model add: subProcess; add: outerTask.
	boundaryController := diagramController newControllerFor: boundaryEvent.
	outerTaskController := diagramController newControllerFor: outerTask.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: boundaryController.
	self
		assert: (outerTaskController canBeTargetFor: flowController)
		description: 'Boundary event on subprocess must be allowed to connect sequence flow to outer task in enclosing scope'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testSequenceFlowCannotCrossPoolBoundaries [
	| pool1 pool2 task1 task2 task1Controller task2Controller flowController |
	pool1 := OPBPMNPoolModel new name: 'Pool 1'.
	pool2 := OPBPMNPoolModel new name: 'Pool 2'.
	task1 := OPBPMNActivityModel new name: 'Task 1'.
	task2 := OPBPMNActivityModel new name: 'Task 2'.
	pool1 add: task1.
	pool2 add: task2.
	model add: pool1; add: pool2.
	task1Controller := diagramController newControllerFor: task1.
	task2Controller := diagramController newControllerFor: task2.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: task1Controller.
	self
		deny: (task2Controller canBeTargetFor: flowController)
		description: 'Sequence flow must not connect nodes belonging to different pools'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testSequenceFlowCannotCrossSubProcessBoundary [
	| subProcess innerTask outerTask innerTaskController outerTaskController flowController |
	subProcess := OPBPMNSubProcessModel new name: 'SubProcess'.
	innerTask := OPBPMNActivityModel new name: 'Inner Task'.
	outerTask := OPBPMNActivityModel new name: 'Outer Task'.
	subProcess add: innerTask.
	model add: subProcess; add: outerTask.
	innerTaskController := diagramController newControllerFor: innerTask.
	outerTaskController := diagramController newControllerFor: outerTask.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: innerTaskController.
	self
		deny: (outerTaskController canBeTargetFor: flowController)
		description: 'Sequence flow must not cross subprocess boundaries'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testSequenceFlowCannotTargetInnerNodeFromBoundaryEventOnSubProcess [
	| subProcess boundaryEvent innerTask boundaryController innerTaskController flowController |
	subProcess := OPBPMNSubProcessModel new name: 'SubProcess'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'BoundaryEvent'.
	innerTask := OPBPMNActivityModel new name: 'InnerTask'.
	subProcess add: boundaryEvent; add: innerTask.
	model add: subProcess.
	boundaryController := diagramController newControllerFor: boundaryEvent.
	innerTaskController := diagramController newControllerFor: innerTask.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: boundaryController.
	self
		deny: (innerTaskController canBeTargetFor: flowController)
		description: 'Boundary event on subprocess must not connect sequence flow into inner node of the subprocess'
]

{ #category : 'tests - sequence flow' }
OPBPMNConnectionAndTargetingRulesTest >> testSequenceFlowCannotTargetOrSourceDataObject [
	| task dataObject taskController dataObjectController flowController |
	task := OPBPMNActivityModel new name: 'Task'.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	model add: task; add: dataObject.
	taskController := diagramController newControllerFor: task.
	dataObjectController := diagramController newControllerFor: dataObject.
	flowController := OPBPMNFlowController new.
	flowController diagramController: diagramController.
	flowController source: taskController.
	self
		deny: (dataObjectController canBeTargetFor: flowController)
		description: 'Sequence flow must not target a data object'.
	flowController source: dataObjectController.
	self
		deny: (taskController canBeTargetFor: flowController)
		description: 'Sequence flow must not be sourced by a data object'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testSubProcessCanBeTargetForAnnotation [
	| subProcessModel subProcessController annotationController |
	subProcessModel := OPBPMNSubProcessModel new.
	subProcessController := diagramController newControllerFor: subProcessModel.
	annotationController := OPBPMNAnnotationController new.
	annotationController diagramController: diagramController.
	self
		assert: (subProcessController canBeTargetFor: annotationController)
		description: 'Expanded subprocess controller must accept annotation controller'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testSubProcessCanBeTargetForDataObject [
	| subProcessModel subProcessController dataObjectController |
	subProcessModel := OPBPMNSubProcessModel new.
	subProcessController := diagramController newControllerFor: subProcessModel.
	dataObjectController := OPBPMNDataObjectController new.
	dataObjectController diagramController: diagramController.
	self
		assert: (subProcessController canBeTargetFor: dataObjectController)
		description: 'Expanded subprocess controller must accept data object controller'
]

{ #category : 'tests - containment' }
OPBPMNConnectionAndTargetingRulesTest >> testSubProcessCanBeTargetForSubProcess [
	| subProcessModel subProcessController nestedSubProcessController |
	subProcessModel := OPBPMNSubProcessModel new.
	subProcessController := diagramController newControllerFor: subProcessModel.
	nestedSubProcessController := OPBPMNSubProcessController new.
	nestedSubProcessController diagramController: diagramController.
	self
		assert: (subProcessController canBeTargetFor: nestedSubProcessController)
		description: 'Expanded subprocess controller must accept nested expanded subprocess controller'
]
