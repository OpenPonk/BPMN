"
I map the underlying BPMN Start Event model to its UI representation and configure its Magritte property forms.
"
Class {
	#name : 'OPBPMNStartEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNStartEventViewModel class >> modelClass [ ^ OPBPMNStartEventModel
]

{ #category : 'forms' }
OPBPMNStartEventViewModel >> buildEditorForm: aForm [

	| droplist timerDrop |
	super buildEditorForm: aForm.
	droplist := aForm
		            bindDroplist: 'Type'
		            property: #type
		            items: #( #None #Receive #Timer #Escalation #Conditional #Error #Compensation #Signal #Multiple #ParallelMultiple ).
	droplist displayIcon: [ :eachType | self typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	aForm bindCheckbox: 'Is Non-Interrupting' property: #isNonInterrupting.
	self model type = OPBPMNNodeType Timer ifFalse: [ ^ self ].
	timerDrop := aForm bindDroplist: 'Timer type' property: #timerType items: #( #none #timeDate #timeDuration #timeCycle ).
	timerDrop display: [ :eachTimerType | eachTimerType asString ].
	aForm bindTextInput: 'Timer value' property: #timerValue
]

{ #category : 'accessing' }
OPBPMNStartEventViewModel >> icon [ ^ OPBPMNIcon current startEvent
]

{ #category : 'accessing' }
OPBPMNStartEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]

{ #category : 'forms' }
OPBPMNStartEventViewModel >> typeIconFor: aType [
	aType = OPBPMNNodeType None ifTrue: [
		^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType Receive ifTrue: [
		^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [
		^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [
		^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional ifTrue: [
		^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [
		^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Compensation ifTrue: [
		^ OPBPMNIcon current eventCatchCompensation ].
	aType = OPBPMNNodeType Signal ifTrue: [
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple ifTrue: [
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [
		^ OPBPMNIcon current eventParallelMultiple ].
	^ super typeIconFor: aType
]
