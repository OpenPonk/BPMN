Class {
	#name : 'OPBPMNPoolModel',
	#superclass : 'OPBPMNSemanticNodeModel',
	#instVars : [
		'laneNames'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNPoolModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : 'announcing' }
OPBPMNPoolModel >> changed [
	super changed.
	owner changed
]

{ #category : 'hooks' }
OPBPMNPoolModel >> enclosingPool [

	^ self
]

{ #category : 'initialization' }
OPBPMNPoolModel >> initialize [ 
	super initialize.
	laneNames := OrderedCollection new.
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneNameAt: aIndex [

	^ laneNames at: aIndex
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneNames [
	^ laneNames
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneNames: aCollection [
	laneNames := aCollection  
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneNamesAt: aIndex put: aText [
	laneNames at: aIndex put: aText
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanes [
	^ self laneNames size
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanes: aNumber [

	| text prevSize |
	text := 'Lane '.
	aNumber < 1 ifTrue: [
			laneNames removeAll.
			^ self ].

	prevSize := laneNames size.
	prevSize + 1 to: aNumber do: [ :i | laneNames add: text , i asString ].
	prevSize to: aNumber + 1 by: -1 do: [ :i | laneNames removeLast ]
]

{ #category : 'accessing' }
OPBPMNPoolModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : 'printing' }
OPBPMNPoolModel >> printType [
	^ 'process'
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeAllNodes [
	self removeAll
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeNode: aNode [
	elements remove: aNode
]
