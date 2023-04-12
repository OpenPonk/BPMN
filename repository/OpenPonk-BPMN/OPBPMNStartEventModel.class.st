Class {
	#name : #OPBPMNStartEventModel,
	#superclass : #OPBPMNEventModel,
	#instVars : [
		'isNonInterrupting'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNStartEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : #printing }
OPBPMNStartEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : #printing }
OPBPMNStartEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : #printing }
OPBPMNStartEventModel >> printType [
	^ 'startEvent'
]

{ #category : #printing }
OPBPMNStartEventModel >> typeIconFor: aType [
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation
		ifTrue: [ ^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional
		ifTrue: [ ^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error
		ifTrue: [ ^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Compensation
		ifTrue: [ ^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType Signal
		ifTrue: [ ^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple
		ifTrue: [ ^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple
		ifTrue: [ ^ OPBPMNIcon current eventParallelMultiple ].
]
