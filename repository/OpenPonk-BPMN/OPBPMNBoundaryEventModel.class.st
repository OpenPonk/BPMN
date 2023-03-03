Class {
	#name : #OPBPMNBoundaryEventModel,
	#superclass : #OPBPMNNodeModel,
	#instVars : [
		'subscribeDiagram',
		'isNonInterrupting'
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

	^ OPBPMNNodeType Error
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : #accessing }
OPBPMNBoundaryEventModel >> nodeNamed: aName [

	^ self elementNamed: aName
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
OPBPMNBoundaryEventModel >> subscribeDiagram: aDiagram [

	subscribeDiagram := aDiagram
]
