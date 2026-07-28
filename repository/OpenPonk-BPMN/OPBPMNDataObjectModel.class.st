Class {
	#name : 'OPBPMNDataObjectModel',
	#superclass : 'OPBPMNSemanticNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNDataObjectModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : 'announcing' }
OPBPMNDataObjectModel >> changed [
	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNDataObjectModel >> defaultType [
	^ OPBPMNNodeType DataObject
]

{ #category : 'accessing' }
OPBPMNDataObjectModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : 'printing' }
OPBPMNDataObjectModel >> printType [
	^ 'dataObject'
]

{ #category : 'removing' }
OPBPMNDataObjectModel >> removeAllNodes [
	self removeAll
]

{ #category : 'removing' }
OPBPMNDataObjectModel >> removeNode: aNode [
	elements remove: aNode
]

{ #category : 'printing' }
OPBPMNDataObjectModel >> typeIconFor: aType [
	aType = OPBPMNNodeType DataObject
		ifTrue: [ ^ OPBPMNIcon current dataObject ].
	aType = OPBPMNNodeType DataInput
		ifTrue: [ ^ OPBPMNIcon current dataInput ].
	aType = OPBPMNNodeType DataOutput
		ifTrue: [ ^ OPBPMNIcon current dataOutput ].
	aType = OPBPMNNodeType DataStore
		ifTrue: [ ^ OPBPMNIcon current dataStore ].
]
