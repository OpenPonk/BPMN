Class {
	#name : #OPBPMNPoolModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'lanes',
		'width',
		'height'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNPoolModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : #accessing }
OPBPMNPoolModel >> changed [
	super changed.
	owner changed
]

{ #category : #accessing }
OPBPMNPoolModel >> height [
	^ height
]

{ #category : #accessing }
OPBPMNPoolModel >> height: aHeight [
	height := aHeight 
]

{ #category : #accessing }
OPBPMNPoolModel >> initialize [ 
	super initialize.
	height := 300.
	width := 500.
	lanes := 1.
]

{ #category : #accessing }
OPBPMNPoolModel >> lanes [
	^ lanes
]

{ #category : #accessing }
OPBPMNPoolModel >> lanes: aNumber [
	lanes := aNumber 
]

{ #category : #accessing }
OPBPMNPoolModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : #accessing }
OPBPMNPoolModel >> nodes [
	^ elements
]

{ #category : #printing }
OPBPMNPoolModel >> printType [
	^ 'process'
]

{ #category : #accessing }
OPBPMNPoolModel >> removeAllNodes [
	self removeAll
]

{ #category : #accessing }
OPBPMNPoolModel >> removeNode: aNode [
	elements remove: aNode
]

{ #category : #accessing }
OPBPMNPoolModel >> width [
	^ width
]

{ #category : #accessing }
OPBPMNPoolModel >> width: aWidth [
	width := aWidth 
]
