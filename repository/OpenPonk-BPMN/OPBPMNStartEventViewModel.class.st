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

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #None #Receive #Timer #Escalation #Conditional #Error #Compensation
			   #Signal #Multiple #ParallelMultiple );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
				self model type: newValue.
				self modelChanged ].
	(aForm addCheckbox: 'Is Non-Interrupting')
		state: self model isNonInterrupting;
		whenChangedDo: [ :val |
				self model isNonInterrupting: val.
				self modelChanged ].

	self model type = OPBPMNNodeType Timer ifFalse: [ ^ self ].
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
				self modelChanged ]
]

{ #category : 'accessing' }
OPBPMNStartEventViewModel >> icon [ ^ OPBPMNIcon current startEvent
]
