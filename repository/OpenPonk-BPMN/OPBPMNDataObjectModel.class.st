Class {
	#name : 'OPBPMNDataObjectModel',
	#superclass : 'OPBPMNNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNDataObjectModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
OPBPMNDataObjectModel >> printType [
	^ 'dataObject'
]

{ #category : 'accessing' }
OPBPMNDataObjectModel >> removeAllNodes [
	self removeAll
]

{ #category : 'accessing' }
OPBPMNDataObjectModel >> removeNode: aNode [
	elements remove: aNode
]

{ #category : 'accessing' }
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
