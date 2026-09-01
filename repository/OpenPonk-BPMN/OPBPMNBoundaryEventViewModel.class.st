"
I map the underlying BPMN Boundary Event model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNBoundaryEventViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel class >> modelClass [ ^ OPBPMNBoundaryEventModel
]

{ #category : 'forms' }
OPBPMNBoundaryEventViewModel >> buildEditorForm: aForm [

	super buildEditorForm: aForm.
	(aForm addDroplist: 'Type')
		items:
			#( #Receive #Timer #Escalation #Conditional #Error #Cancel #CatchCompensation
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
]

{ #category : 'accessing' }
OPBPMNBoundaryEventViewModel >> icon [ ^ OPBPMNIcon current intermediateEvent
]
