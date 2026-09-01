"
I am the core plugin class for the OpenPonk BPMN editor. I register the BPMN diagram controllers, models, layouters, and default UI tools into the OpenPonk environment.
"
Class {
	#name : 'OPBPMNPlugin',
	#superclass : 'OPPlugin',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'toolbar' }
OPBPMNPlugin class >> exportPackage: aPackage [
	StSaveFilePresenter new
		title: 'Choose a BPMN file to export to';
		okAction: [ :file | 
			| message |
			file
				ensureDelete;
				writeStreamDo: [ :stream | 
					stream << (OPBPMNXMLWriter toString: aPackage) ].
			message := String streamContents: [ :s | 
				s << 'Exported to ' << file pathString.
				s cr; cr.
				s << 'Click to open location' ].
			(ProvideAnswerNotification signal: message) ifNil: [
				(GrowlMorph 
					openWithLabel: 'Information' translated 
					contents: message)
					vanishDelay: 5 seconds;
					actionBlock: [ file openInOSFileBrowser ] ] ];
		extensions: #( bpmn xml ) named: 'BPMN XML files';
		open
]

{ #category : 'accessing' }
OPBPMNPlugin class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPBPMNPlugin>
	(aBuilder item: 'Export as XML...')
		icon: OPBPMNIcon current logo;
		action: [ self exportPackage: aBuilder model diagramController ]
]

{ #category : 'accessing' }
OPBPMNPlugin >> diagramControllerClass [
	^ OPBPMNDiagramController
]

{ #category : 'accessing' }
OPBPMNPlugin >> icon [
	^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"
	^ OPBPMNLayouter
]

{ #category : 'accessing' }
OPBPMNPlugin >> modelClass [
	^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : 'accessing' }
OPBPMNPlugin >> name [
	^ 'BPMN'
]

{ #category : 'testing' }
OPBPMNPlugin >> supportsHidingElements [
	^ true
]
