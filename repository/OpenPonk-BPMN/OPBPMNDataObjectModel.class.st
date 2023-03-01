Class {
	#name : #OPBPMNDataObjectModel,
	#superclass : #OPBPMNNodeModel,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNDataObjectModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : #accessing }
OPBPMNDataObjectModel >> changed [
	super changed.
	owner changed
]

{ #category : #accessing }
OPBPMNDataObjectModel >> defaultType [
	^ OPBPMNNodeType DataObject
]

{ #category : #accessing }
OPBPMNDataObjectModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : #accessing }
OPBPMNDataObjectModel >> printType [
	^ 'dataObject'
]

{ #category : #accessing }
OPBPMNDataObjectModel >> removeAllNodes [
	self removeAll
]

{ #category : #accessing }
OPBPMNDataObjectModel >> removeNode: aNode [
	elements remove: aNode
]
