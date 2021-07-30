Class {
	#name : #OPBPMNLayouter,
	#superclass : #OPLayouter,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #accessing }
OPBPMNLayouter >> allEdges [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPBPMNEdgeController ]
		thenCollect: #figure
]

{ #category : #accessing }
OPBPMNLayouter >> allNodes [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPBPMNNodeController ]
		thenCollect: #figure
]

{ #category : #layouts }
OPBPMNLayouter >> defaultLayout [
	self sugiyamaLayout
]
