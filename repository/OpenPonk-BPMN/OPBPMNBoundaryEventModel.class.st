Class {
	#name : #OPBPMNBoundaryEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'subscribeDiagram'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNBoundaryEventModel >> @ aName [

	^ self nodeNamed: aName
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> changed [

	super changed.
	owner changed
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> defaultType [

	^ OPBPMNNodeType Receive
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> printType [

	^ 'boundary'
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> subscribeDiagram [

	^ subscribeDiagram 
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> subscribeDiagram:  aDiagram [

	subscribeDiagram  := aDiagram 
]
