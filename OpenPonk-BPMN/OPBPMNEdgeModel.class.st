Class {
	#name : #OPBPMNEdgeModel,
	#superclass : #OPDirectedAssociation,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #'instance creation' }
OPBPMNEdgeModel class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : #testing }
OPBPMNEdgeModel >> isEdge [
	^ true
]

{ #category : #testing }
OPBPMNEdgeModel >> isNode [
	^ false
]
