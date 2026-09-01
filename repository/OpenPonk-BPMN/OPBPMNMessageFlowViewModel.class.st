"
I am the ViewModel for BPMN Message Flows, bridging the semantic message flow model with its visual dashed-line shape and UI property forms.
"
Class {
	#name : 'OPBPMNMessageFlowViewModel',
	#superclass : 'OPBPMNAbstractFlowViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNMessageFlowViewModel class >> modelClass [ ^ OPBPMNMessageFlowModel
]

{ #category : 'accessing' }
OPBPMNMessageFlowViewModel >> icon [ ^ OPBPMNIcon current messageFlow
]
