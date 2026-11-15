"
I am an abstract base test class verifying diagram interaction, selectable types constraints, and figure refresh logic for semantic BPMN node controllers.
"
Class {
	#name : 'OPBPMNSemanticNodeControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
}

{ #category : 'testing' }
OPBPMNSemanticNodeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNSemanticNodeControllerTest
]

{ #category : 'accessing' }
OPBPMNSemanticNodeControllerTest >> selectableTypes [

	| form dropListForType dropListForMarker |
	form := Mock new.
	dropListForType := SpDropListPresenter new.
	dropListForMarker := SpDropListPresenter new.

	(form stub addDroplist: 'Type') willReturn: dropListForType.
	(form stub addDroplist: 'Marker') willReturn: dropListForMarker.

	(form stub bindDroplist: 'Type' property: Any items: Any) will: [ :labelArg :propertyArg :itemsArg |
		dropListForType items: itemsArg.
		dropListForType ].
	(form stub bindDroplist: 'Marker' property: Any items: Any) will: [ :labelMarkerArg :propertyMarkerArg :itemsMarkerArg |
		dropListForMarker items: itemsMarkerArg.
		dropListForMarker ].

	self controller buildEditorForm: form.
	^ dropListForType items , dropListForMarker items
]

{ #category : 'tests' }
OPBPMNSemanticNodeControllerTest >> testFigureRefresh [

	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert: (controller roassalShape propertyAt: #RSLabeled) text equals: ''.
	controller model name: 'new name'.
	controller modelChanged.
	text := (controller roassalShape propertyAt: #RSLabeled) text.
	self assert: text equals: 'new name'
]

{ #category : 'tests' }
OPBPMNSemanticNodeControllerTest >> testSelectableTypesAreSameAsShowable [

	| selectableTypes allTypes notSelectableTypes |
	self prepareToShow.
	selectableTypes := self selectableTypes.
	allTypes := OPBPMNNodeType class selectors collect: [ :each | (MessageSend receiver: OPBPMNNodeType selector: each) value ].
	notSelectableTypes := allTypes asSet difference: selectableTypes.
	selectableTypes do: [ :each |
			| icon |
			icon := self controller viewModel typeIconFor: each.
			self assert: icon class identicalTo: Form.
			self deny: icon extent equals: 0 @ 0.
			self assert: icon depth equals: 32 ].
	notSelectableTypes do: [ :each |
			| icon |
			icon := nil.
			self should: [ icon := self controller viewModel typeIconFor: each ] raise: OPBPMNUnknownNodeTypeError.
			self assert: icon identicalTo: nil ]
]

{ #category : 'tests' }
OPBPMNSemanticNodeControllerTest >> testSelectableTypesRenderAsVectorShapesWithoutBitmaps [

	| selectableTypes allTypes notSelectableTypes canvas |
	self deny: (self model class canUnderstand: #typeIconFor:) description: 'Domain model must not implement UI typeIconFor: helper'.
	self showInDiagram.
	canvas := diagramController canvas.
	selectableTypes := self selectableTypes.
	allTypes := OPBPMNNodeType class selectors collect: [ :each | (MessageSend receiver: OPBPMNNodeType selector: each) value ].
	notSelectableTypes := allTypes asSet difference: selectableTypes.
	self denyCollection: (canvas shapes collect: #class as: Set) includesAny: { RSBitmap }.
	self denyCollection: (self controller diagramElement attachedShapes collect: #class as: Set) includesAny: { RSBitmap }.
	selectableTypes do: [ :eachType |
			self model type: eachType.
			self controller modelChanged.
			self denyCollection: (canvas shapes collect: #class as: Set) includesAny: { RSBitmap }.
			self denyCollection: (self controller diagramElement attachedShapes collect: #class as: Set) includesAny: { RSBitmap } ].
	selectableTypes ifNotEmpty: [
			notSelectableTypes do: [ :eachInvalidType |
					self
						should: [
								self model type: eachInvalidType.
								self controller diagramElement updateIcon ]
						raise: OPBPMNUnknownNodeTypeError ] ]
]
