Class {
	#name : 'OPBPMNPoolModel',
	#superclass : 'OPBPMNNodeModel',
	#instVars : [
		'lanes',
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

{ #category : 'initialization' }
OPBPMNPoolModel >> initialize [ 
	super initialize.
	lanes := 1.
	laneNames := OrderedCollection new.
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
OPBPMNPoolModel >> laneNamesFitToLanesCount [

	| text prevSize |
	text := 'Lane'.
	lanes < 2 ifTrue: [
			laneNames removeAll.
			^ self ].
		
	prevSize := laneNames size.
	prevSize < (lanes - 1)
		ifTrue: [ prevSize to: lanes - 1 do: [ :i | laneNames add: text ] ]
		ifFalse: [ lanes + 1 to: prevSize do: [ :i | laneNames removeLast ] ]
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanes [
	^ lanes
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanes: aNumber [
	lanes := aNumber 
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
