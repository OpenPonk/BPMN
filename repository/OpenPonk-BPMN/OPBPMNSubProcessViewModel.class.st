"
I map the underlying BPMN SubProcess model to its UI representation, manage its property forms, and expose its contained child elements.
"
Class {
	#name : 'OPBPMNSubProcessViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNSubProcessViewModel class >> modelClass [ ^ OPBPMNSubProcessModel
]

{ #category : 'forms' }
OPBPMNSubProcessViewModel >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	self modelChanged
]

{ #category : 'accessing' }
OPBPMNSubProcessViewModel >> essentialChildrenModels [
			^ self model nodes asArray , (self model nodes flatCollect: [ :each | each outgoing ]) asArray
]

{ #category : 'accessing' }
OPBPMNSubProcessViewModel >> icon [ ^ OPBPMNIcon current expandedSubprocess
]
