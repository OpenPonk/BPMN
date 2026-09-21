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
			#( #Send #Receive #Timer #Escalation #EscalationThrow
			   #Conditional #Link #LinkThrow #Compensation #CompensationThrow
			   #Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple
			   #None ).
	droplist displayIcon: [ :eachType | self model typeIconFor: eachType ].
	droplist display: [ :eachType | eachType asString ].
	self model type = OPBPMNNodeType Timer ifTrue: [
		| timerDrop |
		timerDrop := aForm
			bindDroplist: 'Timer type'
			property: #timerType
			items: #( #none #timeDate #timeDuration #timeCycle ).
		timerDrop display: [ :eachTimerType | eachTimerType asString ].
		aForm bindTextInput: 'Timer value' property: #timerValue ].
	self model type = OPBPMNNodeType Send ifTrue: [
		aForm bindTextInput: 'Executable attribute' property: #executableAttribute.
		aForm bindTextInput: 'Executable attribute value' property: #executableAttributeValue ]
]

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel >> structuralPropertySelectors [
	^ #( #type )
]
