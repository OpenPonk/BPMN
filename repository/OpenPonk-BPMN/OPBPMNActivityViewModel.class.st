"
I am the ViewModel for BPMN Activities (such as Tasks and SubProcesses). I connect the underlying activity model to the editor's visual shapes and property forms.
"
Class {
	#name : 'OPBPMNActivityViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNActivityViewModel class >> modelClass [ ^ OPBPMNActivityModel
]

{ #category : 'forms' }
OPBPMNActivityViewModel >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items: #( #Service #User #Manual #Send #Receive #None );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
				self model type: newValue.
				self modelChanged ].
	(aForm addCheckbox: 'Is Call Activity?')
		state: self model isCallActivity;
		whenChangedDo: [ :val |
				self model isCallActivity: val.
				self modelChanged ].
	self model type = OPBPMNNodeType Service
	| (self model type = OPBPMNNodeType Send)
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
OPBPMNActivityViewModel >> icon [ ^ OPBPMNIcon current activity
]
