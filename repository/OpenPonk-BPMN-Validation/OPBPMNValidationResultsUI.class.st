Class {
	#name : #OPBPMNValidationResultsUI,
	#superclass : #Object,
	#instVars : [
		'controller',
		'validationResults',
		'highlighted',
		'prevColor'
	],
	#category : #'OpenPonk-BPMN-Validation-UI'
}

{ #category : #'instance creation' }
OPBPMNValidationResultsUI class >> createUIFor: aVerificationResults withControllers: aControllers [
	| verUI |
	verUI := self new.
	verUI validationResults: aVerificationResults;
	controller: aControllers.
	^ verUI.
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> changeElementColor: aElement toColor: aColor [
	| diagramElementArray |
	diagramElementArray := (self controller controllers select: [ :aController | aController model = aElement ]) asArray.
	diagramElementArray ifNotEmpty: [ diagramElementArray first diagramElement borderColor: aColor.
		diagramElementArray first diagramElement updateRenderFromSelf. ] .
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> controller [
	^ controller .
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> controller: aController [
	controller := aController.
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> getElementColor: aElement [
	(self controller controllers select: [ :aController | aController model = aElement ])
		do: [ :aController | ^ aController diagramElement borderColor. ].
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> highlightElement: aElement [

	highlighted ifNotNil: [ 
		self changeElementColor: highlighted toColor: prevColor ].
	highlighted := aElement.
	prevColor := self getElementColor: aElement.
	self changeElementColor: aElement toColor: Color green
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> highlighted [
	^ highlighted
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> inspectorTableIn: composite [

	<inspectorPresentationOrder: -15 title: 'Results'>
	^ SpTablePresenter new
		  beResizable;
		  items: self validationResults results asArray;
		  whenSelectedDo: [ :item | self notifySelectChanged: item ];
		  addColumn: (SpStringTableColumn new
				   title: 'Severity';
				   evaluated: #severity;
				   width: 55);
		  addColumn:
		  (SpStringTableColumn title: 'Object' evaluated: #objectReference);
		  addColumn:
		  (SpStringTableColumn title: 'Reason' evaluated: #messageText)
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> notifySelectChanged: aSelection [
	aSelection ifNotNil: [ self highlightElement: aSelection objectReference. ].
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> validationResults [
	^ validationResults.
]

{ #category : #accessing }
OPBPMNValidationResultsUI >> validationResults: aValidationResults [ 
	validationResults := aValidationResults.
]
