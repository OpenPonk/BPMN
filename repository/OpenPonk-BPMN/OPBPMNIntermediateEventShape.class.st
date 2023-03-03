Class {
	#name : #OPBPMNIntermediateEventShape,
	#superclass : #OPBPMNEventShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNIntermediateEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		yourself
]

{ #category : #connecting }
OPBPMNIntermediateEventShape >> renderShapeDetails [

	| label selectable innerCircle|
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new 
		form: self typeIconForModel; 
		yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ 
		icon remove ].
	
	innerCircle := RSCircle new
		size: 31;
		borderColor: Color black;
		color: Color transparent;
		yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ 
		innerCircle remove ].
	
	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #hooks }
OPBPMNIntermediateEventShape >> typeIconFor: aType [
	aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer
		ifTrue: [ ^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation
		ifTrue: [ ^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType EscalationThrow
		ifTrue: [ ^ OPBPMNIcon current eventEscalationThrow ].
	aType = OPBPMNNodeType Conditional
		ifTrue: [ ^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Link
		ifTrue: [ ^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType LinkThrow
		ifTrue: [ ^ OPBPMNIcon current eventLinkThrow ].
	aType = OPBPMNNodeType Compensation
		ifTrue: [ ^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType CompensationThrow
		ifTrue: [ ^ OPBPMNIcon current eventCompensationThrow ].
	aType = OPBPMNNodeType Signal
		ifTrue: [ ^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType SignalThrow
		ifTrue: [ ^ OPBPMNIcon current eventSignalThrow ].
	aType = OPBPMNNodeType Multiple
		ifTrue: [ ^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType MultipleThrow
		ifTrue: [ ^ OPBPMNIcon current eventMultipleThrow ].
	aType = OPBPMNNodeType ParallelMultiple
		ifTrue: [ ^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
