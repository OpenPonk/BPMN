Class {
	#name : #OPBPMNPoolModel,
	#superclass : #OPBPMNNodeModel,
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
OPBPMNPoolModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : #accessing }
OPBPMNPoolModel >> nodes [
	^ self elements
]

{ #category : #accessing }
OPBPMNPoolModel >> removeAllNodes [
	self removeAll
]
