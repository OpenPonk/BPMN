"
I represent a directional BPMN edge linking two nodes. I serve as the base domain model for sequence flows, message flows, and associations.
"
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
