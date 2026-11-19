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
