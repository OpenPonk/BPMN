"
I am an abstract base test class verifying diagram interaction, selectable types constraints, and figure refresh logic for semantic BPMN node controllers.
"
Class {
	#name : 'OPBPMNSemanticNodeControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNSemanticNodeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNSemanticNodeControllerTest
]

{ #category : 'utilities' }
OPBPMNSemanticNodeControllerTest >> selectableTypes [

	| form dropListForType dropListForMarker |
	form := Mock new.
	dropListForType := SpDropListPresenter new.
	dropListForMarker := SpDropListPresenter new.
	(form stub addDroplist: 'Type') willReturn: dropListForType.
	(form stub addDroplist: 'Marker') willReturn: dropListForMarker.
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
	self
		assert: (controller roassalShape propertyAt: #RSLabeled) text
		equals: ''.
	controller model name: 'new name'.
	controller modelChanged.
	text := (controller roassalShape propertyAt: #RSLabeled) text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]

{ #category : 'tests' }
OPBPMNSemanticNodeControllerTest >> testSelectableTypesAreSameAsShowable [

	| selectableTypes allTypes notSelectableTypes |
	self prepareToShow.
	selectableTypes := self selectableTypes.
	allTypes := OPBPMNNodeType class selectors collect: [ :each |
		            (MessageSend receiver: OPBPMNNodeType selector: each)
			            value ].
	notSelectableTypes := allTypes asSet difference: selectableTypes.
	selectableTypes do: [ :each |
			| icon |
			icon := self model typeIconFor: each.
			self assert: icon width > 10 ].
	notSelectableTypes do: [ :each |
			| icon |
			icon := nil.
			self should: [ icon := self model typeIconFor: each ] raise: Error.
			self assert: (icon isNil or: [ icon isForm not ]) ]
]
