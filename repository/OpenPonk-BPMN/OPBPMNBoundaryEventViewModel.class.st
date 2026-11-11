"
I map the underlying BPMN Boundary Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNBoundaryEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel class >> modelClass [ ^ OPBPMNBoundaryEventModel
]

{ #category : 'forms' }
OPBPMNBoundaryEventViewModel >> buildEditorForm: aForm [

	| droplist timerDroplist |
	super buildEditorForm: aForm.
	droplist := aForm
		            bindDroplist: 'Type'
		            property: #type
		            items:
		            #( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation #Signal #Multiple #ParallelMultiple ).
	droplist displayIcon: [ :eachType | self typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	aForm bindCheckbox: 'Is Non-Interrupting' property: #isNonInterrupting.
	self model type = OPBPMNNodeType Timer ifFalse: [ ^ self ].
	timerDroplist := aForm bindDroplist: 'Timer type' property: #timerType items: #( #none #timeDate #timeDuration #timeCycle ).
	timerDroplist display: [ :eachTimerType | eachTimerType asString ].
	aForm bindTextInput: 'Timer value' property: #timerValue
]

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]

{ #category : 'forms' }
OPBPMNBoundaryEventViewModel >> typeIconFor: aType [
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
	aType = OPBPMNNodeType Cancel ifTrue: [
		^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Signal ifTrue: [
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple ifTrue: [
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [
		^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType CatchCompensation ifTrue: [
		^ OPBPMNIcon current eventCatchCompensation ].
	^ super typeIconFor: aType
]
