"
I map the underlying BPMN Intermediate Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNIntermediateEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel class >> modelClass [ ^ OPBPMNIntermediateEventModel
]

{ #category : 'forms' }
OPBPMNIntermediateEventViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		            bindDroplist: 'Type'
		            property: #type
		            items:
			            #( #Send #Receive #Timer #Escalation #EscalationThrow #Conditional #Link #LinkThrow #Compensation #CompensationThrow
			               #Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple #None ).
	droplist displayIcon: [ :eachType | self typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	self model type = OPBPMNNodeType Timer ifTrue: [
			| timerDrop |
			timerDrop := aForm bindDroplist: 'Timer type' property: #timerType items: #( #none #timeDate #timeDuration #timeCycle ).
			timerDrop display: [ :eachTimerType | eachTimerType asString ].
			aForm bindTextInput: 'Timer value' property: #timerValue ].
	self model type = OPBPMNNodeType Send ifFalse: [ ^ self ].
	aForm bindTextInput: 'Executable attribute' property: #executableAttribute.
	aForm bindTextInput: 'Executable attribute value' property: #executableAttributeValue
]

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]

{ #category : 'forms' }
OPBPMNIntermediateEventViewModel >> typeIconFor: aType [
	aType = OPBPMNNodeType Send ifTrue: [
		^ OPBPMNIcon current activitySendSquare ].
	aType = OPBPMNNodeType Receive ifTrue: [
		^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [
		^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [
		^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType EscalationThrow ifTrue: [
		^ OPBPMNIcon current eventEscalationThrow ].
	aType = OPBPMNNodeType Conditional ifTrue: [
		^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Link ifTrue: [
		^ OPBPMNIcon current eventLink ].
	aType = OPBPMNNodeType LinkThrow ifTrue: [
		^ OPBPMNIcon current eventLinkThrow ].
	aType = OPBPMNNodeType Compensation ifTrue: [
		^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType CompensationThrow ifTrue: [
		^ OPBPMNIcon current eventCompensationThrow ].
	aType = OPBPMNNodeType Signal ifTrue: [
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType SignalThrow ifTrue: [
		^ OPBPMNIcon current eventSignalThrow ].
	aType = OPBPMNNodeType Multiple ifTrue: [
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType MultipleThrow ifTrue: [
		^ OPBPMNIcon current eventMultipleThrow ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [
		^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType None ifTrue: [
		^ OPBPMNIcon current activityNone ].
	^ super typeIconFor: aType
]
