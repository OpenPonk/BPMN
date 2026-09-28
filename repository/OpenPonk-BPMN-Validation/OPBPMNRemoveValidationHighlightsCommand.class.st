"
A model command that clears all visual validation error markers from the active BPMN diagram.
"
Class {
	#name : 'OPBPMNRemoveValidationHighlightsCommand',
	#superclass : 'OPBPMNCommand',
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'activation' }
OPBPMNRemoveValidationHighlightsCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPBPMNValidationMenuGroup
		order: 20
		for: OPEditor
]

{ #category : 'accessing' }
OPBPMNRemoveValidationHighlightsCommand >> defaultMenuItemName [
	"Answers the display name of the remove highlights command."
	^ 'Remove highlights'
]

{ #category : 'execution' }
OPBPMNRemoveValidationHighlightsCommand >> execute [
	"Removes all visual validation highlights from diagram elements."
	OPBPMNValidationUI removeHighlightsFromElementsIn: self diagramController
]
