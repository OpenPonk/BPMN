"
I integrate the validation framework into the OpenPonk user interface. I provide toolbar actions to trigger validations and coordinate the visual highlighting of diagram elements.
"
Class {
	#name : 'OPBPMNValidationUI',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'specs' }
OPBPMNValidationUI class >> changeElementColorTo: aColor using: aController [


	(aController respondsTo: #diagramElement) ifFalse: [ ^ self ].
	aController diagramElement strokeColor: aColor.
	aController diagramElement updateRenderFromSelf
]

{ #category : 'specs' }
OPBPMNValidationUI class >> removeHighlightsFromElementsIn: aDiagramController [

	aDiagramController controllers do: [ :controller | 
		self changeElementColorTo: Color black using: controller ].
	aDiagramController updateCanvas
]

{ #category : 'specs' }
OPBPMNValidationUI class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPBPMNPlugin>
	"| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model
		                   profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'BPMN' ]) 
		ifTrue: [ ^ self ].
	"self toolbarMenuItemFor: aBuilder
]

{ #category : 'specs' }
OPBPMNValidationUI class >> toolbarMenuItemFor: aBuilder [

	(aBuilder item: 'Validations')
		icon: OPBPMNIcon current logo;
		action: [  ];
		with: [ 
			(aBuilder item: 'Validate model') action: [ 
					self
						updateValidatedElements: (OPBPMNValidationController new validate:
									 aBuilder model diagramController model)
						using: aBuilder model diagramController ].
			(aBuilder item: 'Remove highlights') action: [ 
					self removeHighlightsFromElementsIn:
							aBuilder model diagramController ] ]
]

{ #category : 'specs' }
OPBPMNValidationUI class >> updateValidatedElementStyle: aVerificationResults using: aController [

	| color |
	"(ValidationController
		 isVerifiable: aController model
		 includeGeneralizations: true) ifFalse: [ ^ self ]."
	"color := aController diagramElement color."
	color := Color black.
	(aVerificationResults hasWarnings: aController model) ifTrue: [ 
		color := Color orange ].
	(aVerificationResults hasErrors: aController model) ifTrue: [ 
		color := Color red ].
	aController diagramElement strokeColor: color.
	aController diagramElement updateRenderFromSelf
]

{ #category : 'specs' }
OPBPMNValidationUI class >> updateValidatedElements: aVerificationResults using: aDiagramController [

	aDiagramController controllers do: [ :controller | 
		self
			updateValidatedElementStyle: aVerificationResults
			using: controller ].
	aDiagramController updateCanvas.
	(OPBPMNValidationResultsUI
		 createUIFor: aVerificationResults
		 withControllers: aDiagramController) inspect
]
