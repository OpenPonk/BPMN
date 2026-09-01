"
I am the ViewModel for BPMN Data Associations, bridging the semantic data flow model with its visual shape and UI property forms.
"
Class {
	#name : 'OPBPMNDataFlowViewModel',
	#superclass : 'OPBPMNAbstractFlowViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNDataFlowViewModel class >> modelClass [ ^ OPBPMNDataFlowModel
]

{ #category : 'accessing' }
OPBPMNDataFlowViewModel >> icon [ ^ OPBPMNIcon current messageFlow
]
