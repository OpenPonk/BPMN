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

	| diagramElement |
	diagramElement := aController diagramElement.
	(diagramElement exists and: [ diagramElement respondsTo: #strokeColor: ]) ifFalse: [ ^ self ].
	diagramElement strokeColor: aColor.
	diagramElement updateRenderFromSelf
]

{ #category : 'specs' }
OPBPMNValidationUI class >> removeHighlightsFromElementsIn: aDiagramController [

	aDiagramController controllers do: [ :controller | 
		self changeElementColorTo: Color black using: controller ].
	aDiagramController updateCanvas
]

{ #category : 'specs' }
OPBPMNValidationUI class >> updateValidatedElementStyle: aVerificationResults using: aController [

	| diagramElement color |
	diagramElement := aController diagramElement.
	(diagramElement exists and: [ diagramElement respondsTo: #strokeColor: ]) ifFalse: [ ^ self ].
	color := Color black.
	(aVerificationResults hasWarnings: aController model) ifTrue: [ color := Color orange ].
	(aVerificationResults hasErrors: aController model) ifTrue: [ color := Color red ].
	diagramElement strokeColor: color.
	diagramElement updateRenderFromSelf
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
