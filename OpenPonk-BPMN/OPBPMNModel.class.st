Class {
	#name : #OPBPMNModel,
	#superclass : #OPModelObject,
	#instVars : [
		'isExecutable'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNModel >> allEntities [
	^ Set with: self nodes
]

{ #category : #accessing }
OPBPMNModel >> edges [
	^ elements select: #isEdge
]

{ #category : #accessing }
OPBPMNModel >> initialize [
	super initialize.
	isExecutable := false.
]

{ #category : #accessing }
OPBPMNModel >> isExecutable [ 
	^ isExecutable
]

{ #category : #accessing }
OPBPMNModel >> isExecutable: aBoolean [
	isExecutable := aBoolean 
]

{ #category : #accessing }
OPBPMNModel >> nodes [
	^ elements select: #isNode
]

{ #category : #accessing }
OPBPMNModel >> printType [
	^ 'process'
]
