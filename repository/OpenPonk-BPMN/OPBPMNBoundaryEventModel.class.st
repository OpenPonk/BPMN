"
I represent a BPMN Boundary Event attached to an activity. I track specific execution semantics, such as whether the event interrupts the host activity.
"
Class {
	#name : 'OPBPMNBoundaryEventModel',
	#superclass : 'OPBPMNSemanticNodeModel',
	#instVars : [
		'isNonInterrupting',
		'timerType',
		'timerValue'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'updating' }
OPBPMNBoundaryEventModel >> changed [

	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> defaultType [

	^ OPBPMNNodeType Error
]

{ #category : 'initialization' }
OPBPMNBoundaryEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : 'printing' }
OPBPMNBoundaryEventModel >> printType [
	^ 'boundaryEvent'
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> timerType [
	^ timerType ifNil: [ #none ]
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> timerType: aType [
	timerType := aType
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> timerValue [
	^ timerValue ifNil: [ '' ]
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> timerValue: aValue [
	timerValue := aValue
]
