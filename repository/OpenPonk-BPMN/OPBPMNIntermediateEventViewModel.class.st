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

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #Send #Receive #Timer #Escalation #EscalationThrow
			   #Conditional #Link #LinkThrow #Compensation #CompensationThrow
			   #Signal #SignalThrow #Multiple #MultipleThrow #ParallelMultiple
			   #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self modelChanged ].
	self model type = OPBPMNNodeType Timer ifTrue: [
		(aForm addDroplist: 'Timer type')
			items: #( #none #timeDate #timeDuration #timeCycle );
			display: [ :type | type asString ];
			selectItem: self model timerType;
			whenSelectedItemChangedDo: [ :newValue |
				self model timerType: newValue.
				self modelChanged ].
		(aForm addText: 'Timer value')
			text: self model timerValue;
			whenTextChangedDo: [ :newValue |
				self model timerValue: newValue asString.
				self modelChanged ] ].
	self model type = OPBPMNNodeType Send
		ifTrue: [
			(aForm addText: 'Executable attribute')
				text: self model executableAttribute;
				whenTextChangedDo: [ :newValue |
					self model executableAttribute: newValue asString.
					self modelChanged ].
			(aForm addText: 'Executable attribute value')
				text: self model executableAttributeValue;
				whenTextChangedDo: [ :newValue |
					self model executableAttributeValue: newValue asString.
					self modelChanged ] ]
		ifFalse: [ self model executableAttribute: nil ]
]

{ #category : 'accessing' }
OPBPMNIntermediateEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]
