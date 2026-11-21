"
Tests automatic hierarchical layout algorithms and element positioning in BPMN collaboration diagrams.
"
Class {
	#name : 'OPBPMNLayouterTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagramController',
		'project',
		'model',
		'diagram',
		'undoManager'
	],
	#category : 'OpenPonk-BPMN-Tests-Plugin',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Plugin'
}

{ #category : 'running' }
OPBPMNLayouterTest >> setUp [
	| projectController |
	super setUp.
	model := OPBPMNExamples exampleOrderFulfillment.
	project := OPProject new.
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
OPBPMNLayouterTest >> tearDown [
	diagramController := nil.
	diagram := nil.
	project := nil.
	model := nil.
	undoManager := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testDefaultLayoutIsUndoable [

	| layouter boundElements initialPositions initialExtents |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	boundElements := (diagramController controllers
		                  select: [ :eachController |
				                  (eachController diagramElement isKindOf: OPBoundNode) and: [
						                  eachController roassalShape isNotNil and: [
							                  eachController diagramElement isPositionableByUser or: [ eachController diagramElement isResizableByUser ] ] ] ]
		                  thenCollect: #diagramElement) asSet.
	self denyEmpty: boundElements.
	initialPositions := Dictionary new.
	initialExtents := Dictionary new.
	boundElements do: [ :eachElement |
			| eachShape |
			eachShape := eachElement roassalShape.
			self assert: eachShape canvas identicalTo: diagramController canvas.
			initialPositions at: eachElement put: eachShape position copy.
			initialExtents at: eachElement put: eachShape extent copy ].
	layouter defaultLayout.
	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager canUndo description: 'Default layout must record an undoable transaction'.
	diagramController undo.
	boundElements do: [ :eachElement |
			| eachShape |
			eachShape := eachElement roassalShape.
			self assert: eachShape canvas identicalTo: diagramController canvas.
			self assert: eachShape position x closeTo: (initialPositions at: eachElement) x precision: 0.5.
			self assert: eachShape position y closeTo: (initialPositions at: eachElement) y precision: 0.5.
			self assert: eachShape extent x closeTo: (initialExtents at: eachElement) x precision: 0.5.
			self assert: eachShape extent y closeTo: (initialExtents at: eachElement) y precision: 0.5 ]
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testDefaultLayoutOnPoollessDiagramArrangesFlowLeftToRight [

	| startModel taskModel endModel dataObjectModel annotationModel flowStartToTask flowTaskToEnd dataFlow association customDiagram customDiagramController customLayouter startShape taskShape endShape dataObjectShape annotationShape |
	model := OPBPMNModel named: 'Poolless Process'.
	startModel := OPBPMNStartEventModel new name: 'Start'.
	taskModel := OPBPMNActivityModel new name: 'Do Work'.
	endModel := OPBPMNEndEventModel new name: 'Done'.
	dataObjectModel := OPBPMNDataObjectModel new name: 'Document'.
	annotationModel := OPBPMNAnnotationModel new text: 'Remark'.
	model
		add: startModel;
		add: taskModel;
		add: endModel;
		add: dataObjectModel;
		add: annotationModel.
	flowStartToTask := OPBPMNFlowModel from: startModel to: taskModel.
	startModel addFlow: flowStartToTask.
	taskModel addFlow: flowStartToTask.
	flowTaskToEnd := OPBPMNFlowModel from: taskModel to: endModel.
	taskModel addFlow: flowTaskToEnd.
	endModel addFlow: flowTaskToEnd.
	dataFlow := OPBPMNDataFlowModel from: dataObjectModel to: taskModel.
	dataObjectModel addFlow: dataFlow.
	taskModel addFlow: dataFlow.
	association := OPBPMNAssociationModel from: annotationModel to: taskModel.
	annotationModel addAssociation: association.
	taskModel addAssociation: association.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter defaultLayout.

	startShape := (customDiagramController controllerForModel: startModel) roassalShape.
	taskShape := (customDiagramController controllerForModel: taskModel) roassalShape.
	endShape := (customDiagramController controllerForModel: endModel) roassalShape.
	dataObjectShape := (customDiagramController controllerForModel: dataObjectModel) roassalShape.
	annotationShape := (customDiagramController controllerForModel: annotationModel) roassalShape.

	self assert: startShape position x < taskShape position x description: 'Start event must sit left of task'.
	self assert: taskShape position x < endShape position x description: 'Task must sit left of end event'.
	self
		assert: annotationShape encompassingRectangle bottom < taskShape encompassingRectangle top
		description: 'Annotation must sit above task'.
	self
		assert: dataObjectShape encompassingRectangle top > taskShape encompassingRectangle bottom
		description: 'Data object must sit below task'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testDirectShapeLookupReturnsNilForMissingInputs [

	| layouter |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	self assert: (layouter directShapeIn: #(  ) forController: nil) identicalTo: nil.
	self assert: (layouter directShapeIn: #(  ) forDiagramElement: nil) identicalTo: nil
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testGridLayoutArrangesTopLevelPoolsDifferentlyFromDefaultLayout [

	| layouter customerShape orderFulfillmentShape defaultDelta gridDelta |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	customerShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Customer' ])
		                 roassalShape.
	orderFulfillmentShape := (diagramController controllers detect: [ :eachController |
		                          eachController model name = 'Order Fulfillment' ]) roassalShape.
	defaultDelta := orderFulfillmentShape position - customerShape position.
	self assert: defaultDelta y abs > 0 description: 'Default layout must stack pools vertically'.

	layouter gridLayout.
	gridDelta := orderFulfillmentShape position - customerShape position.
	self deny: gridDelta equals: defaultDelta.
	self assert: gridDelta x abs > 0 description: 'Grid layout must arrange the two pools horizontally side-by-side'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testLayoutCommandExecutesDefaultLayoutAndAllNodesReturnsRenderedShapes [

	| layouter layoutCommand |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	self assert: layouter allNodes equals: layouter allRenderedNodeShapes.
	self denyEmpty: layouter allNodes.

	layoutCommand := OPBPMNLayoutCommand new.
	layoutCommand instVarNamed: #layouter put: layouter.
	self assert: layoutCommand defaultMenuItemName equals: 'Process Flow'.
	layoutCommand execute.
	self assert: undoManager undoStack size equals: 1
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testPoolEncompassesInnerNodesAfterDefaultLayout [

	| layouter poolController poolShape innerShapes |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	poolController := diagramController controllers detect: [ :eachController |
		                  (eachController isKindOf: OPBPMNPoolController) and: [ eachController model name = 'Order Fulfillment' ] ].
	poolShape := poolController roassalShape.
	innerShapes := poolController diagramElement innerNodeRoassalShapes.
	self denyEmpty: innerShapes.
	innerShapes do: [ :eachNodeShape |
			self
				assert: (poolShape encompassingRectangle containsRect: eachNodeShape encompassingRectangle)
				description: 'Pool bounds must encompass every inner node shape after default layout' ]
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testPoolWithEmptyLanesLayoutsWithoutError [

	| emptyPool mixedPool laneOne laneTwo laneEmpty laneFilled taskModel customDiagram customDiagramController customLayouter emptyPoolShape mixedPoolShape |
	model := OPBPMNModel named: 'Empty Lanes'.
	emptyPool := OPBPMNPoolModel new name: 'All Empty Pool'.
	laneOne := OPBPMNLaneModel new name: 'Empty 1'.
	laneTwo := OPBPMNLaneModel new name: 'Empty 2'.
	emptyPool
		addLane: laneOne;
		addLane: laneTwo.
	mixedPool := OPBPMNPoolModel new name: 'Mixed Pool'.
	laneEmpty := OPBPMNLaneModel new name: 'Idle Lane'.
	laneFilled := OPBPMNLaneModel new name: 'Active Lane'.
	taskModel := OPBPMNActivityModel new name: 'Task'.
	mixedPool
		addLane: laneEmpty;
		addLane: laneFilled.
	laneFilled add: taskModel.
	model
		add: emptyPool;
		add: mixedPool.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter defaultLayout.

	emptyPoolShape := (customDiagramController controllerForModel: emptyPool) roassalShape.
	mixedPoolShape := (customDiagramController controllerForModel: mixedPool) roassalShape.
	self assert: (customDiagramController controllerForModel: laneOne) diagramElement laneHeight equals: 130.
	self assert: (customDiagramController controllerForModel: laneEmpty) diagramElement laneHeight equals: 130.
	self assert: emptyPoolShape width >= 620 description: 'Pool with only empty lanes must keep minimum inner width'.
	self
		assert: (mixedPoolShape encompassingRectangle containsRect:
				 (customDiagramController controllerForModel: taskModel) roassalShape encompassingRectangle)
		description: 'Mixed pool must encompass task in non-empty lane'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testPoolWithLanesAdaptsLaneHeightsToEncompassContainedElementsAfterDefaultLayout [

	| layouter poolController poolShape salesController warehouseController salesShape warehouseShape poolRect salesRect warehouseRect salesNodes warehouseNodes |
	poolController := diagramController controllers detect: [ :eachController |
		                  (eachController isKindOf: OPBPMNPoolController) and: [ eachController model name = 'Order Fulfillment' ] ].
	salesController := diagramController controllers detect: [ :eachController | eachController model name = 'Sales' ].
	warehouseController := diagramController controllers detect: [ :eachController | eachController model name = 'Warehouse' ].
	"Distort lane heights prior to layout to verify stateless adaptation"
	salesController diagramElement laneHeight: 50.
	warehouseController diagramElement laneHeight: 500.
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	poolShape := poolController roassalShape.
	salesShape := salesController roassalShape.
	warehouseShape := warehouseController roassalShape.
	poolRect := poolShape encompassingRectangle.
	salesRect := salesShape encompassingRectangle.
	warehouseRect := warehouseShape encompassingRectangle.

	self assert: salesController diagramElement laneHeight equals: 285.
	self assert: warehouseController diagramElement laneHeight equals: 141.

	salesNodes := salesController diagramElement directNodeRoassalShapes.
	salesNodes do: [ :eachNode |
			self
				assert: (salesRect containsRect: eachNode encompassingRectangle)
				description: 'Sales lane rect must contain every direct node rect' ].

	warehouseNodes := warehouseController diagramElement directNodeRoassalShapes.
	warehouseNodes do: [ :eachNode |
			self
				assert: (warehouseRect containsRect: eachNode encompassingRectangle)
				description: 'Warehouse lane rect must contain every direct node rect' ].

	self assert: (poolRect containsRect: salesRect) description: 'Pool rect must contain Sales lane rect'.
	self assert: (poolRect containsRect: warehouseRect) description: 'Pool rect must contain Warehouse lane rect'.

	self assert: salesRect bottom closeTo: warehouseRect top precision: 0.5.
	self assert: salesRect width closeTo: warehouseRect width precision: 0.5
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testPoolWithLanesStacksLanesVerticallyWithZeroGap [

	| layouter poolController poolShape salesShape warehouseShape salesRect warehouseRect |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.

	poolController := diagramController controllers detect: [ :eachController |
		                  (eachController isKindOf: OPBPMNPoolController) and: [ eachController model name = 'Order Fulfillment' ] ].
	poolShape := poolController roassalShape.
	salesShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Sales' ]) roassalShape.
	warehouseShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Warehouse' ])
		                  roassalShape.

	salesRect := salesShape encompassingRectangle.
	warehouseRect := warehouseShape encompassingRectangle.

	self assert: salesRect width equals: warehouseRect width.
	self assert: salesRect left equals: warehouseRect left.
	self assert: salesRect bottom closeTo: warehouseRect top.
	self assert: (poolShape encompassingRectangle containsRect: salesRect) description: 'Pool bounds must contain Sales lane bounds'.
	self
		assert: (poolShape encompassingRectangle containsRect: warehouseRect)
		description: 'Pool bounds must contain Warehouse lane bounds'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSecondaryShapesDoNotOverlapTargetFlowNodesAfterDefaultLayout [

	| layouter checkStockShape orderDetailsShape slaAnnotationShape checkStockRect orderDetailsRect slaRect |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	checkStockShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Check Stock' ])
		                   roassalShape.
	orderDetailsShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Order Details' ])
		                     roassalShape.
	slaAnnotationShape := (diagramController controllers detect: [ :eachController |
		                       eachController isKindOf: OPBPMNAnnotationController ]) roassalShape.

	checkStockRect := checkStockShape encompassingRectangle.
	orderDetailsRect := orderDetailsShape encompassingRectangle.
	slaRect := slaAnnotationShape encompassingRectangle.

	self
		assert: slaRect bottom <= (checkStockRect top - 15)
		description: 'Annotation must sit clearly above its target activity without overlapping'.
	self
		assert: orderDetailsRect top >= (checkStockRect bottom + 15)
		description: 'Data object must sit clearly below its target activity without overlapping'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSecondaryShapesHandlesReversedAssociationAndUnconnectedSecondaryNodes [

	| taskModel connectedAnnotation unconnectedAnnotation unconnectedDataObject association customDiagram customDiagramController customLayouter taskShape connectedAnnotationShape |
	model := OPBPMNModel named: 'Secondary Shapes'.
	taskModel := OPBPMNActivityModel new name: 'Target Task'.
	connectedAnnotation := OPBPMNAnnotationModel new text: 'Target Annotation'.
	unconnectedAnnotation := OPBPMNAnnotationModel new text: 'Floating Annotation'.
	unconnectedDataObject := OPBPMNDataObjectModel new name: 'Floating Data'.
	model
		add: taskModel;
		add: connectedAnnotation;
		add: unconnectedAnnotation;
		add: unconnectedDataObject.
	association := OPBPMNAssociationModel from: taskModel to: connectedAnnotation.
	taskModel addAssociation: association.
	connectedAnnotation addAssociation: association.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter defaultLayout.

	taskShape := (customDiagramController controllerForModel: taskModel) roassalShape.
	connectedAnnotationShape := (customDiagramController controllerForModel: connectedAnnotation) roassalShape.
	self
		assert: connectedAnnotationShape encompassingRectangle bottom < taskShape encompassingRectangle top
		description: 'Annotation attached as association target must be positioned above its source task'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSequenceFlowFollowsLeftToRightDirection [

	| layouter startShape checkStockShape gatewayShape subProcessShape shipmentShape endShape orderedPositions |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	startShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Order Placed' ])
		              roassalShape.
	checkStockShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Check Stock' ])
		                   roassalShape.
	gatewayShape := (diagramController controllers detect: [ :eachController | eachController model name = 'In Stock?' ])
		                roassalShape.
	subProcessShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Procure Items' ])
		                   roassalShape.
	shipmentShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Prepare Shipment' ])
		                 roassalShape.
	endShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Order Delivered' ])
		            roassalShape.

	orderedPositions := {
		                    startShape.
		                    checkStockShape.
		                    gatewayShape.
		                    subProcessShape.
		                    shipmentShape.
		                    endShape } collect: [ :eachShape | eachShape position x ].
	self assert: orderedPositions equals: #( 108.0 246.0 388.0 660.0 1074.0 1317.0 )
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSubProcessEncompassesInnerNodesAfterDefaultLayout [

	| layouter subProcessController subProcessShape innerTaskController innerTaskShape subProcessRect taskRect |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	subProcessController := diagramController controllers detect: [ :eachController |
		                        (eachController isKindOf: OPBPMNSubProcessController) and: [
			                        eachController model name = 'Procure Items' ] ].
	subProcessShape := subProcessController roassalShape.
	innerTaskController := diagramController controllers detect: [ :eachController | eachController model name = 'Order from Vendor' ].
	innerTaskShape := innerTaskController roassalShape.
	subProcessRect := subProcessShape encompassingRectangle.
	taskRect := innerTaskShape encompassingRectangle.
	self assert: (subProcessRect containsRect: taskRect) description: [
			String streamContents: [ :stream |
					stream << 'SubProcess rect '.
					stream print: subProcessRect.
					stream << ' does not contain inner task rect '.
					stream print: taskRect ] ]
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSubProcessWithSingleInnerNodeLayoutsAndEncompassesNode [

	| subProcessModel innerTaskModel customDiagram customDiagramController customLayouter subProcessShape innerTaskShape |
	model := OPBPMNModel named: 'Single Inner SubProcess'.
	subProcessModel := OPBPMNSubProcessModel new name: 'SubProcess'.
	innerTaskModel := OPBPMNActivityModel new name: 'Only Task'.
	subProcessModel add: innerTaskModel.
	model add: subProcessModel.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter defaultLayout.

	subProcessShape := (customDiagramController controllerForModel: subProcessModel) roassalShape.
	innerTaskShape := (customDiagramController controllerForModel: innerTaskModel) roassalShape.
	self
		assert: (subProcessShape encompassingRectangle containsRect: innerTaskShape encompassingRectangle)
		description: 'SubProcess must encompass its single inner node after layout'
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testTreeLayoutOnCyclicCollaborationFallsBackToGridInSingleUndoTransaction [

	| poolA poolB taskA taskB messageAB messageBA customDiagram customDiagramController customLayouter poolAShape poolBShape initialAPosition initialBPosition rectA rectB |
	model := OPBPMNModel named: 'Cyclic Collaboration'.
	poolA := OPBPMNPoolModel new name: 'Pool A'.
	poolB := OPBPMNPoolModel new name: 'Pool B'.
	taskA := OPBPMNActivityModel new name: 'Send Request'.
	taskB := OPBPMNActivityModel new name: 'Send Reply'.
	poolA add: taskA.
	poolB add: taskB.
	model
		add: poolA;
		add: poolB.
	messageAB := OPBPMNMessageFlowModel from: taskA to: taskB.
	taskA addFlow: messageAB.
	taskB addFlow: messageAB.
	messageBA := OPBPMNMessageFlowModel from: taskB to: taskA.
	taskB addFlow: messageBA.
	taskA addFlow: messageBA.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	poolAShape := (customDiagramController controllerForModel: poolA) roassalShape.
	poolBShape := (customDiagramController controllerForModel: poolB) roassalShape.
	initialAPosition := poolAShape position copy.
	initialBPosition := poolBShape position copy.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter treeLayout.

	rectA := poolAShape encompassingRectangle.
	rectB := poolBShape encompassingRectangle.
	self assert: undoManager undoStack size equals: 1.
	self
		assert: (rectB left >= rectA right or: [ rectA left >= rectB right ])
		description: 'Cyclic tree layout must fall back to grid layout placing pools side by side'.
	customDiagramController undo.
	self assert: poolAShape position x closeTo: initialAPosition x precision: 0.5.
	self assert: poolAShape position y closeTo: initialAPosition y precision: 0.5.
	self assert: poolBShape position x closeTo: initialBPosition x precision: 0.5.
	self assert: poolBShape position y closeTo: initialBPosition y precision: 0.5
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testUnpartitionedPoolLayoutEncompassesInnerNodesAndArrangesFlowLeftToRight [

	| poolModel startModel taskModel endModel dataObjectModel annotationModel flowStartToTask flowTaskToEnd dataFlow association customDiagram customDiagramController customLayouter poolShape startShape taskShape endShape dataObjectShape annotationShape poolRect |
	model := OPBPMNModel named: 'Unpartitioned Process'.
	poolModel := OPBPMNPoolModel new name: 'Single Pool'.
	startModel := OPBPMNStartEventModel new name: 'Start'.
	taskModel := OPBPMNActivityModel new name: 'Execute Work'.
	endModel := OPBPMNEndEventModel new name: 'End'.
	dataObjectModel := OPBPMNDataObjectModel new name: 'Input Data'.
	annotationModel := OPBPMNAnnotationModel new text: 'Important Note'.
	poolModel
		add: startModel;
		add: taskModel;
		add: endModel;
		add: dataObjectModel;
		add: annotationModel.
	flowStartToTask := OPBPMNFlowModel from: startModel to: taskModel.
	startModel addFlow: flowStartToTask.
	taskModel addFlow: flowStartToTask.
	flowTaskToEnd := OPBPMNFlowModel from: taskModel to: endModel.
	taskModel addFlow: flowTaskToEnd.
	endModel addFlow: flowTaskToEnd.
	dataFlow := OPBPMNDataFlowModel from: dataObjectModel to: taskModel.
	dataObjectModel addFlow: dataFlow.
	taskModel addFlow: dataFlow.
	association := OPBPMNAssociationModel from: annotationModel to: taskModel.
	annotationModel addAssociation: association.
	taskModel addAssociation: association.
	model add: poolModel.

	project := OPProject new.
	project addModel: model.
	customDiagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: customDiagram.
	undoManager := OPUndoManager new.
	customDiagramController := OPBPMNDiagramController new.
	(OPProjectController forProject: project)
		instVarNamed: #undoManager put: undoManager;
		addDiagramController: customDiagramController.
	customDiagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: customDiagram;
		model: model.
	customDiagramController showAllElements.

	customLayouter := OPBPMNLayouter new diagramController: customDiagramController.
	customLayouter defaultLayout.

	poolShape := (customDiagramController controllerForModel: poolModel) roassalShape.
	startShape := (customDiagramController controllerForModel: startModel) roassalShape.
	taskShape := (customDiagramController controllerForModel: taskModel) roassalShape.
	endShape := (customDiagramController controllerForModel: endModel) roassalShape.
	dataObjectShape := (customDiagramController controllerForModel: dataObjectModel) roassalShape.
	annotationShape := (customDiagramController controllerForModel: annotationModel) roassalShape.
	poolRect := poolShape encompassingRectangle.

	{
		startShape.
		taskShape.
		endShape.
		dataObjectShape.
		annotationShape } do: [ :eachInnerShape |
			self
				assert: (poolRect containsRect: eachInnerShape encompassingRectangle)
				description: 'Unpartitioned pool must encompass every inner shape after default layout' ].
	self assert: startShape position x < taskShape position x description: 'Start event must sit left of task'.
	self assert: taskShape position x < endShape position x description: 'Task must sit left of end event'.
	self
		assert: annotationShape encompassingRectangle bottom < taskShape encompassingRectangle top
		description: 'Annotation must sit above task'.
	self
		assert: dataObjectShape encompassingRectangle top > taskShape encompassingRectangle bottom
		description: 'Data object must sit below task'
]
