"
I am the abstract base ViewModel for semantic BPMN nodes (such as activities, gateways, and events). I handle standard UI form building and property descriptions for the Magritte framework.
"
Class {
	#name : 'OPBPMNSemanticNodeViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPBPMNSemanticNodeViewModel class >> isAbstract [

	^ self = OPBPMNSemanticNodeViewModel
]

{ #category : 'accessing' }
OPBPMNSemanticNodeViewModel class >> modelClass [ ^ OPBPMNSemanticNodeModel
]

{ #category : 'forms' }
OPBPMNSemanticNodeViewModel >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextChangedDo: [ :newValue | 
			self model name: newValue asString.
			self modelChanged ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeViewModel >> childrenModels [

	^ self model nodes asArray , self model outgoing asArray
]
