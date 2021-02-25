Class {
	#name : #OPBPMNNodeModel,
	#superclass : #OPBPMNModel,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNNodeModel >> incoming [
	owner ifNil: [ ^ #() ].
	^ owner edges select: [ :each | each target = self ]
]

{ #category : #testing }
OPBPMNNodeModel >> isEdge [
	^ false
]

{ #category : #testing }
OPBPMNNodeModel >> isNode [
	^ true
]

{ #category : #accessing }
OPBPMNNodeModel >> outgoing [
	owner ifNil: [ ^ #() ].
	^ owner edges select: [ :each | each source = self ]
]
