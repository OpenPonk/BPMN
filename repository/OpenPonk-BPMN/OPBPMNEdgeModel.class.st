Class {
	#name : 'OPBPMNEdgeModel',
	#superclass : 'OPDirectedAssociation',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'testing' }
OPBPMNEdgeModel >> isEdge [
	^ true
]

{ #category : 'testing' }
OPBPMNEdgeModel >> isNode [
	^ false
]
