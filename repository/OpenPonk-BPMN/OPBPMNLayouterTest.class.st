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
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
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
				                  (eachController respondsTo: #diagramElement) and: [
						                  (eachController diagramElement isKindOf: OPBoundNode) and: [
								                  eachController roassalShape isNotNil and: [
									                  eachController diagramElement isPositionableByUser or: [
										                  eachController diagramElement isResizableByUser ] ] ] ] ]
		                  thenCollect: #diagramElement) asSet.
	initialPositions := Dictionary new.
	initialExtents := Dictionary new.
	boundElements do: [ :eachElement |
			eachElement roassalShape ifNotNil: [ :eachShape |
					initialPositions at: eachElement put: eachShape position copy.
					initialExtents at: eachElement put: eachShape extent copy ] ].
	layouter defaultLayout.
	self assert: undoManager canUndo.
	diagramController undo.
	boundElements do: [ :eachElement |
			eachElement roassalShape ifNotNil: [ :eachShape |
					self assert: eachShape position x closeTo: (initialPositions at: eachElement) x precision: 0.5.
					self assert: eachShape position y closeTo: (initialPositions at: eachElement) y precision: 0.5.
					self assert: eachShape extent x closeTo: (initialExtents at: eachElement) x precision: 0.5.
					self assert: eachShape extent y closeTo: (initialExtents at: eachElement) y precision: 0.5 ] ]
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
	self assert: innerShapes isNotEmpty.
	innerShapes do: [ :eachNodeShape |
		self assert: (poolShape encompassingRectangle containsRect: eachNodeShape encompassingRectangle) ]
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

	self
		assert: salesController diagramElement laneHeight >= 100
		description: [ 'Sales lane height ' , salesController diagramElement laneHeight asString , ' should be at least 100' ].
	self
		assert: warehouseController diagramElement laneHeight >= 100
		description: [ 'Warehouse lane height ' , warehouseController diagramElement laneHeight asString , ' should be at least 100' ].

	salesNodes := salesController diagramElement directNodeRoassalShapes.
	salesNodes do: [ :eachNode |
		self
			assert: (salesRect containsRect: eachNode encompassingRectangle)
			description: [ 'Sales lane rect ' , salesRect asString , ' does not contain node rect ' , eachNode encompassingRectangle asString ] ].

	warehouseNodes := warehouseController diagramElement directNodeRoassalShapes.
	warehouseNodes do: [ :eachNode |
		self
			assert: (warehouseRect containsRect: eachNode encompassingRectangle)
			description: [ 'Warehouse lane rect ' , warehouseRect asString , ' does not contain node rect ' , eachNode encompassingRectangle asString ] ].

	self
		assert: (poolRect containsRect: salesRect)
		description: [ 'Pool rect ' , poolRect asString , ' does not contain Sales rect ' , salesRect asString ].
	self
		assert: (poolRect containsRect: warehouseRect)
		description: [ 'Pool rect ' , poolRect asString , ' does not contain Warehouse rect ' , warehouseRect asString ].

	self
		assert: (salesRect bottom closeTo: warehouseRect top precision: 0.5)
		description: [ 'Sales bottom ' , salesRect bottom asString , ' does not meet Warehouse top ' , warehouseRect top asString ].
	self
		assert: (salesRect width closeTo: warehouseRect width precision: 0.5)
		description: [ 'Sales width ' , salesRect width asString , ' does not match Warehouse width ' , warehouseRect width asString ]
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testPoolWithLanesStacksLanesVerticallyWithZeroGap [
	| layouter poolController poolShape salesShape warehouseShape salesRect warehouseRect |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.

	poolController := diagramController controllers detect: [ :eachController |
		(eachController isKindOf: OPBPMNPoolController) and: [ eachController model name = 'Order Fulfillment' ] ].
	poolShape := poolController roassalShape.
	salesShape := (diagramController controllers detect: [ :eachController |
		eachController model name = 'Sales' ]) roassalShape.
	warehouseShape := (diagramController controllers detect: [ :eachController |
		eachController model name = 'Warehouse' ]) roassalShape.

	salesRect := salesShape encompassingRectangle.
	warehouseRect := warehouseShape encompassingRectangle.

	self assert: salesRect width equals: warehouseRect width.
	self assert: salesRect left equals: warehouseRect left.
	self assert: (salesRect bottom closeTo: warehouseRect top).
	self assert: (poolShape encompassingRectangle containsRect: salesRect).
	self assert: (poolShape encompassingRectangle containsRect: warehouseRect)
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSequenceFlowFollowsLeftToRightDirection [
	| layouter startShape checkStockShape gatewayShape subProcessShape shipmentShape endShape |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	startShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Order Placed' ]) roassalShape.
	checkStockShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Check Stock' ]) roassalShape.
	gatewayShape := (diagramController controllers detect: [ :eachController | eachController model name = 'In Stock?' ]) roassalShape.
	subProcessShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Procure Items' ]) roassalShape.
	shipmentShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Prepare Shipment' ]) roassalShape.
	endShape := (diagramController controllers detect: [ :eachController | eachController model name = 'Order Delivered' ]) roassalShape.

	self assert: startShape position x < checkStockShape position x.
	self assert: checkStockShape position x < gatewayShape position x.
	self assert: gatewayShape position x < subProcessShape position x.
	self assert: subProcessShape position x < shipmentShape position x.
	self assert: shipmentShape position x < endShape position x
]

{ #category : 'tests' }
OPBPMNLayouterTest >> testSubProcessEncompassesInnerNodesAfterDefaultLayout [
	| layouter subProcessController subProcessShape innerTaskController innerTaskShape subProcessRect taskRect |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	subProcessController := diagramController controllers detect: [ :eachController |
		(eachController isKindOf: OPBPMNSubProcessController) and: [ eachController model name = 'Procure Items' ] ].
	subProcessShape := subProcessController roassalShape.
	innerTaskController := diagramController controllers detect: [ :eachController |
		eachController model name = 'Order from Vendor' ].
	innerTaskShape := innerTaskController roassalShape.
	subProcessRect := subProcessShape encompassingRectangle.
	taskRect := innerTaskShape encompassingRectangle.
	self
		assert: (subProcessRect containsRect: taskRect)
		description: [ 'SubProcess rect ' , subProcessRect asString , ' does not contain inner task rect ' , taskRect asString ]
]
