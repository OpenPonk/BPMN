"
I am a specialized graph layouter for BPMN diagrams, applying automated spatial arrangements specifically tailored for pools, lanes, nodes, and sequence flows.
"
Class {
	#name : 'OPBPMNLayouter',
	#superclass : 'OPHierarchicalNodesAndEdgesLayouter',
	#category : 'OpenPonk-BPMN-Plugin',
	#package : 'OpenPonk-BPMN',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPBPMNLayouter class >> supportedLayoutCommands [
	"Answers layout commands supported by the BPMN diagram toolbar."

	^ {
		OPBPMNLayoutCommand.
		OPDominanceTreeLayoutCommand.
		OPGridLayoutCommand.
		OPSugiyamaLayoutCommand.
		OPTreeLayoutCommand }
]

{ #category : 'accessing' }
OPBPMNLayouter >> allEdges [
	"Answers all relationship shapes rendered in the diagram."

	| relationshipControllers |
	relationshipControllers := diagramController controllers select: [ :eachController |
		eachController isKindOf: OPBPMNEdgeController ].
	^ (relationshipControllers collect: #roassalShape thenSelect: #isNotNil) asGroup
]

{ #category : 'accessing' }
OPBPMNLayouter >> allNodes [
	"Answers all rendered bound node shapes on canvas as an RSGroup for undo snapshotting."

	^ self allRenderedNodeShapes
]

{ #category : 'userinterface' }
OPBPMNLayouter >> applyLayout: aTwoArgBlock [
	| allTargetNodes snapshot activeContainers topLevelBoxes commands |
	allTargetNodes := self allRenderedNodeShapes.
	snapshot := OPDiagramGeometrySnapshot onNodes: allTargetNodes.

	activeContainers := self containerElementsBottomUp.
	self layoutContainersHierarchically: activeContainers.

	topLevelBoxes := self topLevelNodeShapes.

	RSVerticalLineLayout new
		gapSize: 60;
		on: topLevelBoxes.

	self unsubscribeContainers: activeContainers.

	commands := snapshot deltaCommands.
	self executeLayoutCommands: commands.
	self updateCanvas
]

{ #category : 'accessing' }
OPBPMNLayouter >> containerElementsBottomUp [
	"Answers all active container diagram elements in diagram, excluding swimlanes which are laid out globally by their owning pool."
	^ (super containerElementsBottomUp reject: [ :eachElement |
		eachElement isKindOf: OPBPMNLaneShape ]) asArray
]

{ #category : 'layouts' }
OPBPMNLayouter >> defaultLayout [
	"Applies the default hierarchical process layout to pools and contained semantic nodes."

	self applyLayout: [ :nodes :edges | ]
]

{ #category : 'private' }
OPBPMNLayouter >> directShapeIn: aCollectionOfShapes forController: aNodeController [
	"Answers the roassal shape in the given shape collection for a node controller by delegating to its diagram element."
	aNodeController ifNil: [ ^ nil ].
	^ self directShapeIn: aCollectionOfShapes forDiagramElement: aNodeController diagramElement
]

{ #category : 'private' }
OPBPMNLayouter >> directShapeIn: aCollectionOfShapes forDiagramElement: aDiagramElement [
	"Answers the roassal shape in the given shape collection that corresponds to the given diagram element or its enclosing container."
	| currentElement rootDiagram |
	aDiagramElement ifNil: [ ^ nil ].
	(aCollectionOfShapes includes: aDiagramElement roassalShape) ifTrue: [
		^ aDiagramElement roassalShape ].
	rootDiagram := diagramController diagramElement.
	currentElement := aDiagramElement owningElement.
	[ currentElement isNotNil and: [ currentElement isContainer and: [ currentElement ~~ rootDiagram ] ] ] whileTrue: [
		(aCollectionOfShapes includes: currentElement roassalShape) ifTrue: [
			^ currentElement roassalShape ].
		currentElement := currentElement owningElement ].
	^ nil
]

{ #category : 'processing' }
OPBPMNLayouter >> layoutHorizontalFlowShapes: aCollectionOfFlowShapes edges: aCollectionOfLayoutEdges [
	"Assigns horizontal ranks and positions flow shapes from left to right along sequence flow edges."

	| ranks maxRank nodesByRank currentX horizontalGap verticalGap |
	ranks := Dictionary new.
	aCollectionOfFlowShapes do: [ :eachShape | ranks at: eachShape put: 0 ].
	aCollectionOfFlowShapes size timesRepeat: [
		aCollectionOfLayoutEdges do: [ :eachEdge |
			| sourceRank targetRank |
			sourceRank := ranks at: eachEdge key ifAbsent: [ 0 ].
			targetRank := ranks at: eachEdge value ifAbsent: [ 0 ].
			targetRank < (sourceRank + 1) ifTrue: [
				ranks at: eachEdge value put: sourceRank + 1 ] ] ].
	maxRank := ranks values ifEmpty: [ 0 ] ifNotEmpty: [ :valuesCollection | valuesCollection max ].
	nodesByRank := Dictionary new.
	0 to: maxRank do: [ :eachRank |
		nodesByRank at: eachRank put: OrderedCollection new ].
	ranks keysAndValuesDo: [ :eachShape :eachRank |
		(nodesByRank at: eachRank) add: eachShape ].
	currentX := 50.
	horizontalGap := 60.
	verticalGap := 50.
	0 to: maxRank do: [ :eachRankIndex |
		| columnShapes columnMaxWidth totalColumnHeight runningY |
		columnShapes := nodesByRank at: eachRankIndex.
		columnShapes ifNotEmpty: [
			columnMaxWidth := (columnShapes collect: [ :eachShape | eachShape extent x ]) max.
			totalColumnHeight := (columnShapes sum: [ :eachShape | eachShape extent y ]) + ((columnShapes size - 1) * verticalGap).
			runningY := 0 - (totalColumnHeight / 2).
			columnShapes do: [ :eachShape |
				| shapeCenterY |
				shapeCenterY := runningY + (eachShape extent y / 2).
				eachShape translateTo: (currentX + (columnMaxWidth / 2)) @ shapeCenterY.
				runningY := runningY + eachShape extent y + verticalGap ].
			currentX := currentX + columnMaxWidth + horizontalGap ] ]
]

{ #category : 'layouts' }
OPBPMNLayouter >> layoutInnerContentOf: aContainerElement shapes: directShapes edges: directEdges [
	"Dispatches inner layout algorithm based on whether the container is a subprocess, pool with lanes, or unpartitioned pool."
	(aContainerElement isKindOf: OPBPMNSubProcessShape) ifTrue: [
		^ self layoutSubProcessContent: aContainerElement shapes: directShapes edges: directEdges ].
	((aContainerElement isKindOf: OPBPMNPoolShape) and: [ aContainerElement hasLanes ]) ifTrue: [
		^ self layoutPoolWithLanes: aContainerElement shapes: directShapes ].
	self layoutPoolContent: aContainerElement shapes: directShapes edges: directEdges
]

{ #category : 'layouts' }
OPBPMNLayouter >> layoutPoolContent: aPoolShape shapes: directShapes edges: directEdges [
	"Arranges pool flow nodes horizontally and secondary shapes around them."
	| secondaryShapes flowShapes flowEdges |
	secondaryShapes := (directShapes select: [ :eachShape |
		(eachShape model isKindOf: OPBPMNDataObjectShape) or: [
			eachShape model isKindOf: OPBPMNAnnotationShape ] ]) asGroup.
	flowShapes := (directShapes copyWithoutAll: secondaryShapes) asGroup.
	flowEdges := self sequenceFlowLayoutEdgesForNodes: flowShapes.
	self layoutHorizontalFlowShapes: flowShapes edges: flowEdges.
	self layoutSecondaryShapes: secondaryShapes
]

{ #category : 'layouting' }
OPBPMNLayouter >> layoutPoolWithLanes: aPoolShape shapes: aCollectionOfLaneShapes [
	| lanes allFlowShapes allSecondaryShapes flowEdges ranks maxRank nodesByRank columnCenters currentX horizontalGap startX startY currentY allNodes poolInnerWidth |
	lanes := aPoolShape laneShapes.
	lanes ifEmpty: [ ^ self ].

	allFlowShapes := (lanes flatCollect: [ :eachLane |
		eachLane directNodeRoassalShapes reject: [ :eachShape |
			eachShape model isSecondaryLayoutShape ] ]) asGroup.

	allSecondaryShapes := (lanes flatCollect: [ :eachLane |
		eachLane directNodeRoassalShapes select: [ :eachShape |
			eachShape model isSecondaryLayoutShape ] ]) asGroup.

	flowEdges := self sequenceFlowLayoutEdgesForNodes: allFlowShapes.

	ranks := Dictionary new.
	allFlowShapes do: [ :eachShape | ranks at: eachShape put: 0 ].
	allFlowShapes size timesRepeat: [
		flowEdges do: [ :eachEdge |
			| sourceRank targetRank |
			sourceRank := ranks at: eachEdge key ifAbsent: [ 0 ].
			targetRank := ranks at: eachEdge value ifAbsent: [ 0 ].
			targetRank < (sourceRank + 1) ifTrue: [
				ranks at: eachEdge value put: sourceRank + 1 ] ] ].

	maxRank := ranks values ifEmpty: [ 0 ] ifNotEmpty: [ :valuesCollection | valuesCollection max ].
	nodesByRank := Dictionary new.
	0 to: maxRank do: [ :eachRank |
		nodesByRank at: eachRank put: OrderedCollection new ].
	ranks keysAndValuesDo: [ :eachShape :eachRank |
		(nodesByRank at: eachRank) add: eachShape ].

	columnCenters := Dictionary new.
	currentX := 60.
	horizontalGap := 50.

	0 to: maxRank do: [ :eachRankIndex |
		| columnShapes columnMaxWidth columnCenterX |
		columnShapes := nodesByRank at: eachRankIndex.
		columnShapes ifNotEmpty: [
			columnMaxWidth := (columnShapes collect: [ :eachShape | eachShape extent x ]) max.
			columnCenterX := currentX + (columnMaxWidth / 2).
			columnCenters at: eachRankIndex put: columnCenterX.
			currentX := currentX + columnMaxWidth + horizontalGap ] ].

	lanes do: [ :eachLane |
		0 to: maxRank do: [ :eachRankIndex |
			| columnShapes columnCenterX |
			columnShapes := (nodesByRank at: eachRankIndex) select: [ :eachShape |
				eachShape model owningElement == eachLane ].
			columnShapes ifNotEmpty: [
				| totalColumnHeight runningY |
				columnCenterX := columnCenters at: eachRankIndex ifAbsent: [ currentX ].
				totalColumnHeight := (columnShapes sum: [ :eachShape | eachShape extent y ]) + ((columnShapes size - 1) * 30).
				runningY := 0 - (totalColumnHeight / 2).
				columnShapes do: [ :eachShape |
					eachShape translateTo: columnCenterX @ (runningY + (eachShape extent y / 2)).
					runningY := runningY + eachShape extent y + 30 ] ] ] ].

	self layoutSecondaryShapes: allSecondaryShapes.

	allNodes := (lanes flatCollect: #directNodeRoassalShapes) asGroup.
	poolInnerWidth := allNodes ifEmpty: [ 600 ] ifNotEmpty: [
		(allNodes encompassingRectangle right + 40 max: 600) asInteger ].

	startX := 0.
	startY := 0.
	currentY := startY.

	lanes do: [ :eachLane |
		| laneNodes calculatedHeight laneCenterX laneCenterY eachLaneShape |
		laneNodes := eachLane directNodeRoassalShapes.
		calculatedHeight := laneNodes
			ifEmpty: [ 100 ]
			ifNotEmpty: [
				| nodesRect |
				nodesRect := (RSGroup withAll: laneNodes) encompassingRectangle.
				((nodesRect height + 50) max: 100) asInteger ].
		eachLane laneHeight: calculatedHeight.

		laneCenterY := currentY + (calculatedHeight / 2).
		laneCenterX := startX + aPoolShape nameAreaWidth + (poolInnerWidth / 2).

		laneNodes ifNotEmpty: [
			| nodesRect deltaY |
			nodesRect := (RSGroup withAll: laneNodes) encompassingRectangle.
			deltaY := laneCenterY - nodesRect floatCenter y.
			(RSGroup withAll: laneNodes) translateBy: (0 @ deltaY) ].

		eachLaneShape := eachLane roassalShape.
		eachLaneShape
			extent: poolInnerWidth @ calculatedHeight;
			translateTo: laneCenterX @ laneCenterY.

		currentY := currentY + calculatedHeight ].

	aPoolShape roassalShape extent: (poolInnerWidth + aPoolShape nameAreaWidth) @ currentY.
	aPoolShape roassalShape translateTo:
		(startX + ((poolInnerWidth + aPoolShape nameAreaWidth) / 2)) @ (startY + (currentY / 2)).
	aPoolShape lastRectangle: aPoolShape roassalShape encompassingRectangle.
	aPoolShape updateNameArea
]

{ #category : 'layouts' }
OPBPMNLayouter >> layoutSecondaryShapes: aCollectionOfSecondaryShapes [
	"Positions annotations above and data objects below their associated flow nodes."
	aCollectionOfSecondaryShapes do: [ :eachSecondaryShape |
		(eachSecondaryShape model isKindOf: OPBPMNAnnotationShape) ifTrue: [
			| associationController |
			associationController := diagramController controllers detect: [ :eachController |
				(eachController isKindOf: OPBPMNAssociationController) and: [
					eachController source roassalShape == eachSecondaryShape or: [
						eachController target roassalShape == eachSecondaryShape ] ] ]
				ifNone: [ nil ].
			associationController ifNotNil: [
				| targetNodeShape |
				targetNodeShape := associationController source roassalShape == eachSecondaryShape
					ifTrue: [ associationController target roassalShape ]
					ifFalse: [ associationController source roassalShape ].
				eachSecondaryShape translateTo:
					targetNodeShape position x @ (targetNodeShape position y - 65) ] ].
		(eachSecondaryShape model isKindOf: OPBPMNDataObjectShape) ifTrue: [
			| dataFlowController |
			dataFlowController := diagramController controllers detect: [ :eachController |
				(eachController isKindOf: OPBPMNDataFlowController) and: [
					eachController source roassalShape == eachSecondaryShape or: [
						eachController target roassalShape == eachSecondaryShape ] ] ]
				ifNone: [ nil ].
			dataFlowController ifNotNil: [
				| targetNodeShape |
				targetNodeShape := dataFlowController source roassalShape == eachSecondaryShape
					ifTrue: [ dataFlowController target roassalShape ]
					ifFalse: [ dataFlowController source roassalShape ].
				eachSecondaryShape translateTo:
					targetNodeShape position x @ (targetNodeShape position y + 65) ] ] ]
]

{ #category : 'layouts' }
OPBPMNLayouter >> layoutSecondaryShapes: aCollectionOfSecondaryShapes inPool: anIgnoredPool [
	"Delegates secondary shape layout directly."
	self layoutSecondaryShapes: aCollectionOfSecondaryShapes
]

{ #category : 'layouts' }
OPBPMNLayouter >> layoutSubProcessContent: aSubProcessShape shapes: directShapes edges: directEdges [
	"Arranges inner nodes of a subprocess with horizontal dominance tree layout."
	directShapes ifNotEmpty: [
		directShapes size = 1
			ifTrue: [ directShapes first translateTo: 0 @ 0 ]
			ifFalse: [
				RSHorizontalDominanceTreeLayout new
					horizontalGap: 40;
					verticalGap: 30;
					on: directShapes.
				directShapes translateTo: 0 @ 0 ] ]
]

{ #category : 'processing' }
OPBPMNLayouter >> sequenceFlowLayoutEdgesForNodes: aCollectionOfShapes [
	"Answers associations representing sequence flow dependencies (sourceShape -> targetShape)."

	| flowControllers layoutEdges |
	flowControllers := diagramController controllers select: [ :eachController | eachController isKindOf: OPBPMNFlowController ].
	layoutEdges := OrderedCollection new.
	^ flowControllers
		  collect: [ :eachFlowController |
				  | sourceShape targetShape |
				  sourceShape := self directShapeIn: aCollectionOfShapes forController: eachFlowController source.
				  targetShape := self directShapeIn: aCollectionOfShapes forController: eachFlowController target.
				  sourceShape -> targetShape ]
		  thenSelect: [ :sourceAndTargetShape |
				  | sourceShape targetShape |
				  sourceShape := sourceAndTargetShape key.
				  targetShape := sourceAndTargetShape value.
				  sourceShape isNotNil and: [ targetShape isNotNil and: [ sourceShape ~~ targetShape ] ] ]
]

{ #category : 'layouts' }
OPBPMNLayouter >> wirePositionPropagationFor: aContainerElement children: aCollectionOfShapes [
	"Subscribes to container shape position change to synchronously translate inner lane flow nodes."
	| innerShapesToPropagate |
	innerShapesToPropagate := OrderedCollection new.
	(aContainerElement isKindOf: OPBPMNPoolShape)
		ifTrue: [
			aContainerElement laneShapes do: [ :eachLane |
				innerShapesToPropagate addAll: eachLane directNodeRoassalShapes ] ]
		ifFalse: [
			innerShapesToPropagate addAll: aCollectionOfShapes ].
	super wirePositionPropagationFor: aContainerElement children: innerShapesToPropagate asGroup
]
