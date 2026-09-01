"
I map the underlying BPMN End Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNEndEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNEndEventViewModel class >> modelClass [ ^ OPBPMNEndEventModel
]

{ #category : 'forms' }
OPBPMNEndEventViewModel >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Send #EscalationThrow #Error #Cancel #CompensationThrow
			   #SignalThrow #MultipleThrow #Terminate #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self modelChanged ].
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
OPBPMNEndEventViewModel >> icon [ ^ OPBPMNIcon current endEvent
]
