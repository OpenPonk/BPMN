Class {
	#name : #OPBPMNStartEventShape,
	#superclass : #OPBPMNEventShape,
	#instVars : [
		'border'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNStartEventShape >> createBorder [

	self modelElement
		ifNil: [ 
			border := RSBorder new
				          dashArray: #( 1 0 );
				          color: Color black ]
		ifNotNil: [ 
			self modelElement isNonInterrupting
				ifTrue: [ border dashArray: #( 11 10 ) ]
				ifFalse: [ border dashArray: #( 1 0 ) ] ]
]

{ #category : #connecting }
OPBPMNStartEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		border: border;
		yourself
]

{ #category : #connecting }
OPBPMNStartEventShape >> initialize [
	super initialize.
	self createBorder.
	
]

{ #category : #hooks }
OPBPMNStartEventShape >> typeIconFor: aType [
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

{ #category : #connecting }
OPBPMNStartEventShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	super updateRenderFromModel.

	roassalShape signalUpdate
]
