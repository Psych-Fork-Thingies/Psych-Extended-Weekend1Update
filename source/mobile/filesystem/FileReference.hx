package mobile.filesystem;

#if !flash
import haxe.io.Path;
import haxe.Timer;
import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;
#if lime
import lime.utils.Bytes;
#end
#if (lime && !macro)
import lime.ui.FileDialog;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if (js && html5)
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
#end

/**
	The FileReference class provides a means to upload and download files
	between a user's computer and a server. An operating-system dialog box
	prompts the user to select a file to upload or a location for download.
	Each FileReference object refers to a single file on the user's disk and
	has properties that contain information about the file's size, type, name,
	creation date, modification date, and creator type (Macintosh only).
	**Note:** In Adobe AIR, the File class, which extends the FileReference
	class, provides more capabilities and has less security restrictions than
	the FileReference class.

	FileReference instances are created in the following ways:

	* When you use the `new` operator with the FileReference constructor: `var
	myFileReference = new FileReference();`
	* When you call the `FileReferenceList.browse()` method, which creates an
	array of FileReference objects.

	During an upload operation, all the properties of a FileReference object
	are populated by calls to the `FileReference.browse()` or
	`FileReferenceList.browse()` methods. During a download operation, the
	`name` property is populated when the `select` event is dispatched; all
	other properties are populated when the `complete` event is dispatched.

	The `browse()` method opens an operating-system dialog box that prompts
	the user to select a file for upload. The `FileReference.browse()` method
	lets the user select a single file; the `FileReferenceList.browse()`
	method lets the user select multiple files. After a successful call to the
	`browse()` method, call the `FileReference.upload()` method to upload one
	file at a time. The `FileReference.download()` method prompts the user for
	a location to save the file and initiates downloading from a remote URL.

	The FileReference and FileReferenceList classes do not let you set the
	default file location for the dialog box that the `browse()` or
	`download()` methods generate. The default location shown in the dialog
	box is the most recently browsed folder, if that location can be
	determined, or the desktop. The classes do not allow you to read from or
	write to the transferred file. They do not allow the SWF file that
	initiated the upload or download to access the uploaded or downloaded file
	or the file's location on the user's disk.

	The FileReference and FileReferenceList classes also do not provide
	methods for authentication. With servers that require authentication, you
	can download files with the Flash<sup>®</sup> Player browser plug-in, but
	uploading (on all players) and downloading (on the stand-alone or external
	player) fails. Listen for FileReference events to determine whether
	operations complete successfully and to handle errors.

	For content running in Flash Player or for content running in Adobe AIR
	outside of the application security sandbox, uploading and downloading
	operations can access files only within its own domain and within any
	domains that a URL policy file specifies. Put a policy file on the file
	server if the content initiating the upload or download doesn't come from
	the same domain as the file server.

	Note that because of new functionality added to the Flash Player, when
	publishing to Flash Player 10, you can have only one of the following
	operations active at one time: `FileReference.browse()`,
	`FileReference.upload()`, `FileReference.download()`,
	`FileReference.load()`, `FileReference.save()`. Otherwise, Flash Player
	throws a runtime error (code 2174). Use `FileReference.cancel()` to stop
	an operation in progress. This restriction applies only to Flash Player
	10. Previous versions of Flash Player are unaffected by this restriction
	on simultaneous multiple operations.

	While calls to the `FileReference.browse()`, `FileReferenceList.browse()`,
	or `FileReference.download()` methods are executing, SWF file playback
	pauses in stand-alone and external versions of Flash Player and in AIR for
	Linux and Mac OS X 10.1 and earlier

	The following sample HTTP `POST` request is sent from Flash Player to a
	server-side script if no parameters are specified:

	```
	POST /handler.cfm HTTP/1.1
	Accept: text/*
	Content-Type: multipart/form-data;
	boundary=----------Ij5ae0ae0KM7GI3KM7
	User-Agent: Shockwave Flash
	Host: www.example.com
	Content-Length: 421
	Connection: Keep-Alive
	Cache-Control: no-cache

	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filename"

	MyFile.jpg
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filedata"; filename="MyFile.jpg"
	Content-Type: application/octet-stream

	FileDataHere
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Upload"

	Submit Query
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7--
	```

	Flash Player sends the following HTTP `POST` request if the user specifies
	the parameters `"api_sig"`, `"api_key"`, and `"auth_token"`:

	```
	POST /handler.cfm HTTP/1.1
	Accept: text/*
	Content-Type: multipart/form-data;
	boundary=----------Ij5ae0ae0KM7GI3KM7
	User-Agent: Shockwave Flash
	Host: www.example.com
	Content-Length: 421
	Connection: Keep-Alive
	Cache-Control: no-cache

	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filename"

	MyFile.jpg
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="api_sig"

	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="api_key"

	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="auth_token"

	XXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filedata"; filename="MyFile.jpg"
	Content-Type: application/octet-stream

	FileDataHere
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Upload"

	Submit Query
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7--
	```

	@event cancel             Dispatched when a file upload or download is
							  canceled through the file-browsing dialog box by
							  the user. Flash Player does not dispatch this
							  event if the user cancels an upload or download
							  through other means (closing the browser or
							  stopping the current application).
	@event complete           Dispatched when download is complete or when
							  upload generates an HTTP status code of 200. For
							  file download, this event is dispatched when
							  Flash Player or Adobe AIR finishes downloading
							  the entire file to disk. For file upload, this
							  event is dispatched after the Flash Player or
							  Adobe AIR receives an HTTP status code of 200
							  from the server receiving the transmission.
	@event httpResponseStatus Dispatched if a call to the `upload()` or
							  `uploadUnencoded()` method attempts to access
							  data over HTTP and Adobe AIR is able to detect
							  and return the status code for the request.
	@event httpStatus         Dispatched when an upload fails and an HTTP
							  status code is available to describe the
							  failure. The `httpStatus` event is dispatched,
							  followed by an `ioError` event.
							  The `httpStatus` event is dispatched only for
							  upload failures. For content running in Flash
							  Player this event is not applicable for download
							  failures. If a download fails because of an HTTP
							  error, the error is reported as an I/O error.
	@event ioError            Dispatched when the upload or download fails. A
							  file transfer can fail for one of the following
							  reasons:
							  * An input/output error occurs while the player
							  is reading, writing, or transmitting the file.
							  * The SWF file tries to upload a file to a
							  server that requires authentication (such as a
							  user name and password). During upload, Flash
							  Player or Adobe AIR does not provide a means for
							  users to enter passwords. If a SWF file tries to
							  upload a file to a server that requires
							  authentication, the upload fails.
							  * The SWF file tries to download a file from a
							  server that requires authentication, within the
							  stand-alone or external player. During download,
							  the stand-alone and external players do not
							  provide a means for users to enter passwords. If
							  a SWF file in these players tries to download a
							  file from a server that requires authentication,
							  the download fails. File download can succeed
							  only in the ActiveX control, browser plug-in
							  players, and the Adobe AIR runtime.
							  * The value passed to the `url` parameter in the
							  `upload()` method contains an invalid protocol.
							  Valid protocols are HTTP and HTTPS.

							  **Important:** Only applications running in a
							  browser ?that is, using the browser plug-in
							  or ActiveX control ?and content running in
							  Adobe AIR can provide a dialog box to prompt the
							  user to enter a user name and password for
							  authentication, and then only for downloads. For
							  uploads using the plug-in or ActiveX control
							  version of Flash Player, or for upload or
							  download using either the stand-alone or the
							  external player, the file transfer fails.
	@event open               Dispatched when an upload or download operation
							  starts.
	@event progress           Dispatched periodically during the file upload
							  or download operation. The `progress` event is
							  dispatched while Flash Player transmits bytes to
							  a server, and it is periodically dispatched
							  during the transmission, even if the
							  transmission is ultimately not successful. To
							  determine if and when the file transmission is
							  actually successful and complete, listen for the
							  `complete` event.
							  In some cases, `progress` events are not
							  received. For example, when the file being
							  transmitted is very small or the upload or
							  download happens very quickly a `progress` event
							  might not be dispatched.

							  File upload progress cannot be determined on
							  Macintosh platforms earlier than OS X 10.3. The
							  `progress` event is called during the upload
							  operation, but the value of the `bytesLoaded`
							  property of the progress event is -1, indicating
							  that the progress cannot be determined.
	@event securityError      Dispatched when a call to the
							  `FileReference.upload()` or
							  `FileReference.download()` method tries to
							  upload a file to a server or get a file from a
							  server that is outside the caller's security
							  sandbox. The value of the text property that
							  describes the specific error that occurred is
							  normally `"securitySandboxError"`. The calling
							  SWF file may have tried to access a SWF file
							  outside its domain and does not have permission
							  to do so. You can try to remedy this error by
							  using a URL policy file.
							  In Adobe AIR, these security restrictions do not
							  apply to content in the application security
							  sandbox.

							  In Adobe AIR, these security restrictions do not
							  apply to content in the application security
							  sandbox.
	@event select             Dispatched when the user selects a file for
							  upload or download from the file-browsing dialog
							  box. (This dialog box opens when you call the
							  `FileReference.browse()`,
							  `FileReferenceList.browse()`, or
							  `FileReference.download()` method.) When the
							  user selects a file and confirms the operation
							  (for example, by clicking OK), the properties of
							  the FileReference object are populated.
							  For content running in Flash Player or outside
							  of the application security sandbox in the Adobe
							  AIR runtime, the `select` event acts slightly
							  differently depending on what method invokes it.
							  When the `select` event is dispatched after a
							  `browse()` call, the OpenFL application can read
							  all the FileReference object's properties, because
							  the file selected by the user is on the local file
							  system. When the `select` event occurs after a
							  `download()` call, the OpenFL application can read
							  only the `name` property, because the file hasn't
							  yet been downloaded to the local file system at the
							  moment the `select` event is dispatched. When the
							  file is downloaded and the `complete` even
							  dispatched, the OpenFL application can read all
							  other properties of the FileReference object.
	@event uploadCompleteData Dispatched after data is received from the
							  server after a successful upload. This event is
							  not dispatched if data is not returned from the
							  server.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FileReference extends EventDispatcher
{
	/**
		The creation date of the file on the local disk. If the object is was
		not populated, a call to get the value of this property returns
		`null`.

		@throws IOError               If the file information cannot be
									  accessed, an exception is thrown with a
									  message indicating a file I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `creationDate` property is `null`.
	**/
	public var creationDate(get, null):Date;

	/**
		The Macintosh creator type of the file, which is only used in Mac OS
		versions prior to Mac OS X. In Windows or Linux, this property is
		`null`. If the FileReference object was not populated, a call to get
		the value of this property returns `null`.

		@throws IllegalOperationError On Macintosh, if the
									  `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `creator` property is `null`.
	**/
	public var creator(default, null):String;

	/**
		The ByteArray object representing the data from the loaded file after
		a successful call to the `load()` method.

		@throws IOError               If the file cannot be opened or read, or
									  if a similar error is encountered in
									  accessing the file, an exception is
									  thrown with a message indicating a file
									  I/O error. In this case, the value of
									  the `data` property is `null`.
		@throws IllegalOperationError If the `load()` method was not called
									  successfully, an exception is thrown
									  with a message indicating that functions
									  were called in the incorrect sequence or
									  an earlier call was unsuccessful. In
									  this case, the value of the `data`
									  property is `null`.
	**/
	public var data(default, null):ByteArray;

	/**
		The date that the file on the local disk was last modified. If the
		FileReference object was not populated, a call to get the value of
		this property returns `null`.

		@throws IOError               If the file information cannot be
									  accessed, an exception is thrown with a
									  message indicating a file I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `modificationDate` property is
									  `null`.
	**/
	public var modificationDate(get, null):Date;

	/**
		The name of the file on the local disk. If the FileReference object
		was not populated (by a valid call to `FileReference.download()` or `
		FileReference.browse()`), Flash Player throws an error when you try to
		get the value of this property.
		All the properties of a FileReference object are populated by calling
		the `browse()` method. Unlike other FileReference properties, if you
		call the `download()` method, the `name` property is populated when
		the `select` event is dispatched.

		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful.
	**/
	public var name(get, null):String;

	/**
		The size of the file on the local disk in bytes. If `size` is 0, an
		exception is thrown.

		_Note:_ In the initial version of ActionScript 3.0, the `size`
		property was defined as a `uint` object, which supported files with
		sizes up to about 4 GB. It was later implemented as a `Number` object to
		support larger files. In OpenFL, it is `Float` to match `Number`.

		@throws IOError               If the file cannot be opened or read, or
									  if a similar error is encountered in
									  accessing the file, an exception is
									  thrown with a message indicating a file
									  I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful.
	**/
	public var size(get, null):Float;

	/**
		The file type.
		In Windows or Linux, this property is the file extension. On the
		Macintosh, this property is the four-character file type, which is
		only used in Mac OS versions prior to Mac OS X. If the FileReference
		object was not populated, a call to get the value of this property
		returns `null`.

		For Windows, Linux, and Mac OS X, the file extension ?the portion
		of the `name` property that follows the last occurrence of the dot (.)
		character ?identifies the file type.

		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `type` property is `null`.
	**/
	public var type(get, null):String;

	/**
		The filename extension.

		A file's extension is 