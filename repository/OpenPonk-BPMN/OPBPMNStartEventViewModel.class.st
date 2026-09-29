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
	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Type'
		property: #type
		items:
			#( #None #Receive #Timer #Escalation #Conditional #Error #Compensation
			   #Signal #Multiple #ParallelMultiple ).
	droplist displayIcon: [ :eachType | self model typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	aForm bindCheckbox: 'Is Non-Interrupting' property: #isNonInterrupting.
	self model type = OPBPMNNodeType Timer ifTrue: [
		| timerDrop |
		timerDrop := aForm
			bindDroplist: 'Timer type'
			property: #timerType
			items: #( #none #timeDate #timeDuration #timeCycle ).
		timerDrop display: [ :eachTimerType | eachTimerType asString ].
		aForm bindTextInput: 'Timer value' property: #timerValue ]
]

{ #category : 'accessing' }
OPBPMNStartEventViewModel >> icon [ ^ OPBPMNIcon current startEvent
]

{ #category : 'accessing' }
OPBPMNStartEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]
