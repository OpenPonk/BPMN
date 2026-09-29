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
			self assert: (eachShape position closeTo: (initialPositions at: eachElement) precision: 0.5).
			eachElement isResizableByUser
				ifTrue: [ self assert: eachShape extent equals: (initialExtents at: eachElement) ]
				ifFalse: [ self assert: (eachShape extent closeTo: (initialExtents at: eachElement)) ] ] ]
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
	| layouter subProcessController subProcessShape innerTaskController innerTaskShape |
	layouter := OPBPMNLayouter new diagramController: diagramController.
	layouter defaultLayout.
	subProcessController := diagramController controllers detect: [ :eachController |
		(eachController isKindOf: OPBPMNSubProcessController) and: [ eachController model name = 'Procure Items' ] ].
	subProcessShape := subProcessController roassalShape.
	innerTaskController := diagramController controllers detect: [ :eachController |
		eachController model name = 'Order from Vendor' ].
	innerTaskShape := innerTaskController roassalShape.
	self assert: (subProcessShape encompassingRectangle containsRect: innerTaskShape encompassingRectangle)
]
