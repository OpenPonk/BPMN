"
I am a specialized graph layouter for BPMN diagrams, applying automated spatial arrangements specifically tailored for pools, lanes, nodes, and sequence flows.
"
Class {
	#name : 'OPBPMNLayouter',
	#superclass : 'OPNodesAndEdgesLayouter',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
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
