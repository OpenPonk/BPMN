Class {
	#name : 'OPBPMNLayouter',
	#superclass : 'OPLayouter',
	#category : 'OpenPonk-BPMN-Adapters',
	#package : 'OpenPonk-BPMN',
	#tag : 'Adapters'
}

{ #category : 'accessing' }
OPBPMNLayouter >> allEdges [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPBPMNEdgeController ]
		thenCollect: #roassalShape
]

{ #category : 'accessing' }
OPBPMNLayouter >> allNodes [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPBPMNNodeController ]
		thenCollect: #roassalShape
]

{ #category : 'layouts' }
OPBPMNLayouter >> defaultLayout [
	self sugiyamaLayout
]
