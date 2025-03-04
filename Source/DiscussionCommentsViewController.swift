//
//  DiscussionCommentsViewController.swift
//  edX
//
//  Created by Tang, Jeff on 5/28/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit

private var commentTextStyle : OEXTextStyle {
    return OEXTextStyle(weight: .normal, size: .base, color : OEXStyles.shared().neutralBlack())
}

private var smallTextStyle : OEXTextStyle {
    return OEXTextStyle(weight: .normal, size: .base, color : OEXStyles.shared().primaryXLightColor())
}

private var reportTextStyle : OEXTextStyle {
    return OEXTextStyle(weight: .normal, size: .base, color : OEXStyles.shared().infoBase())
}

private var smallIconStyle : OEXTextStyle {
    return OEXTextStyle(weight: .normal, size: .base, color: OEXStyles.shared().primaryXLightColor())
}

private let smallIconSelectedStyle = smallIconStyle.withColor(OEXStyles.shared().primaryBaseColor())

private let UserProfileImageSize = CGSize(width: 40, height: 40)

class DiscussionCommentCell: UITableViewCell {
    
    private let bodyTextView = UITextView()
    private let authorButton = UIButton(type: .system)
    private let commentCountOrReportIconButton = UIButton(type: .system)
    private let divider = UIView()
    private let containerView = UIView()
    fileprivate let endorsedLabel = UILabel()
    private let authorProfileImage = UIImageView()
    private let authorNameLabel = UILabel()
    private let dateLabel = UILabel()
    
    fileprivate var endorsedTextStyle : OEXTextStyle {
        return OEXTextStyle(weight: .normal, size: .small, color: OEXStyles.shared().successBase())
    }
    
    private func setEndorsed(endorsed : Bool) {
        endorsedLabel.isHidden = !endorsed
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        applyStandardSeparatorInsets()
        addSubViews()
        setConstraints()
        bodyTextView.isEditable = false
        bodyTextView.dataDetectorTypes = UIDataDetectorTypes.all
        bodyTextView.isScrollEnabled = false
        bodyTextView.backgroundColor = UIColor.clear
        containerView.isUserInteractionEnabled = true
        commentCountOrReportIconButton.localizedHorizontalContentAlignment = .Trailing
        contentView.backgroundColor = OEXStyles.shared().discussionsBackgroundColor
        divider.backgroundColor = OEXStyles.shared().discussionsBackgroundColor
        containerView.backgroundColor = OEXStyles.shared().neutralWhiteT()
        containerView.applyBorderStyle(style: BorderStyle())
        accessibilityTraits = UIAccessibilityTraits.header
        bodyTextView.isAccessibilityElement = false
        setAccessibilityIdentifiers()
    }

    private func setAccessibilityIdentifiers() {
        contentView.accessibilityIdentifier = "DiscussionCommentCell:content-view"
        bodyTextView.accessibilityIdentifier = "DiscussionCommentCell:body-text-view"
        authorButton.accessibilityIdentifier = "DiscussionCommentCell:author-button"
        commentCountOrReportIconButton.accessibilityIdentifier = "DiscussionCommentCell:comment-count-or-report-icon-button"
        divider.accessibilityIdentifier = "DiscussionCommentCell:divider-view"
        containerView.accessibilityIdentifier = "DiscussionCommentCell:container-view"
        endorsedLabel.accessibilityIdentifier = "DiscussionCommentCell:endorsed-label"
        authorProfileImage.accessibilityIdentifier = "DiscussionCommentCell:author-profile-image-view"
        authorNameLabel.accessibilityIdentifier = "DiscussionCommentCell:author-name-label"
        dateLabel.accessibilityIdentifier = "DiscussionCommentCell:date-label"
    }
    
    private func addSubViews() {
       contentView.addSubview(containerView)
        containerView.addSubview(bodyTextView)
        containerView.addSubview(authorButton)
        containerView.addSubview(endorsedLabel)
        containerView.addSubview(commentCountOrReportIconButton)
        containerView.addSubview(divider)
        containerView.addSubview(authorProfileImage)
        containerView.addSubview(authorNameLabel)
        containerView.addSubview(dateLabel)
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.init(top: 0, left: StandardHorizontalMargin, bottom: 0, right: StandardHorizontalMargin))
        }
        
        authorProfileImage.snp.makeConstraints { make in
            make.leading.equalTo(containerView).offset(StandardHorizontalMargin)
            make.top.equalTo(containerView).offset(StandardVerticalMargin)
            make.width.equalTo(UserProfileImageSize.width)
            make.height.equalTo(UserProfileImageSize.height)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(authorProfileImage)
            make.leading.equalTo(authorProfileImage.snp.trailing).offset(StandardHorizontalMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorNameLabel.snp.bottom)
            make.leading.equalTo(authorNameLabel)
        }
        
        authorButton.snp.makeConstraints { make in
            make.top.equalTo(authorProfileImage)
            make.leading.equalTo(contentView)
            make.bottom.equalTo(authorProfileImage)
            make.trailing.equalTo(dateLabel)
            make.trailing.equalTo(authorNameLabel)
        }
        
        endorsedLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom)
        }
        
        bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(authorProfileImage.snp.bottom).offset(StandardVerticalMargin)
            make.leading.equalTo(authorProfileImage)
            make.trailing.equalTo(containerView).offset(-StandardHorizontalMargin)
        }
        
        commentCountOrReportIconButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).offset(-OEXStyles.shared().standardHorizontalMargin())
            make.top.equalTo(authorNameLabel)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(bodyTextView.snp.bottom).offset(StandardVerticalMargin)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.height.equalTo(StandardVerticalMargin)
            make.bottom.equalTo(containerView)
        }
    }
    
    func useResponse(response : DiscussionComment, viewController : DiscussionCommentsViewController) {
        divider.snp.updateConstraints { make in
            make.height.equalTo(StandardVerticalMargin)
        }
        bodyTextView.attributedText = commentTextStyle.markdownString(withText: response.renderedBody)
        DiscussionHelper.styleAuthorDetails(author: response.author, authorLabel: response.authorLabel, createdAt: response.createdAt, hasProfileImage: response.hasProfileImage, imageURL: response.imageURL, authoNameLabel: authorNameLabel, dateLabel: dateLabel, authorButton: authorButton, imageView: authorProfileImage, viewController: viewController, router: viewController.environment.router)
        
        let message = Strings.comment(count: response.childCount)
        let buttonTitle = NSAttributedString.joinInNaturalLayout(attributedStrings: [
            Icon.Comment.attributedTextWithStyle(style: smallIconStyle),
            smallTextStyle.attributedString(withText: message)])
        commentCountOrReportIconButton.setAttributedTitle(buttonTitle, for: .normal)
        
        setEndorsed(endorsed: response.endorsed)
        setNeedsLayout()
        layoutIfNeeded()
        
        DiscussionHelper.styleAuthorProfileImageView(imageView: authorProfileImage)
        
        setAccessiblity(commentCount: commentCountOrReportIconButton.currentAttributedTitle?.string)
    }
    
    func useComment(comment : DiscussionComment, inViewController viewController : DiscussionCommentsViewController, index: NSInteger) {
        divider.snp.updateConstraints { make in
            make.height.equalTo(2)
        }
        bodyTextView.attributedText = commentTextStyle.markdownString(withText: comment.renderedBody)
        updateReportText(button: commentCountOrReportIconButton, report: comment.abuseFlagged)
        DiscussionHelper.styleAuthorDetails(author: comment.author, authorLabel: comment.authorLabel, createdAt: comment.createdAt, hasProfileImage: comment.hasProfileImage, imageURL: comment.imageURL, authoNameLabel: authorNameLabel, dateLabel: dateLabel, authorButton: authorButton, imageView: authorProfileImage, viewController: viewController, router: viewController.environment.router)
        
        commentCountOrReportIconButton.oex_removeAllActions()
        commentCountOrReportIconButton.oex_addAction({[weak viewController] _ -> Void in
            
            let apiRequest = DiscussionAPI.flagComment(abuseFlagged: !comment.abuseFlagged, commentID: comment.commentID)
            viewController?.environment.networkManager.taskForRequest(apiRequest) { result in
                if let response = result.data {
                    if (viewController?.comments.count)! > index && viewController?.comments[index].commentID == response.commentID {
                        let patchedComment = self.patchComment(oldComment: viewController?.comments[index], newComment: response)
                        viewController?.comments[index] = patchedComment
                        self.updateReportText(button: self.commentCountOrReportIconButton, report: response.abuseFlagged)
                        viewController?.tableView.reloadData()
                    }
                }
                else {
                    viewController?.showOverlay(withMessage: DiscussionHelper.messageForError(error: result.error))
                }
            }
            }, for: UIControl.Event.touchUpInside)
        
        
        setEndorsed(endorsed: false)
        setNeedsLayout()
        layoutIfNeeded()
        DiscussionHelper.styleAuthorProfileImageView(imageView: authorProfileImage)
        
        setAccessiblity(commentCount: nil)
    }
    
    private func patchComment(oldComment: DiscussionComment?, newComment: DiscussionComment)-> DiscussionComment {
        var patchComment = newComment
        patchComment.hasProfileImage = oldComment?.hasProfileImage ?? false
        patchComment.imageURL = oldComment?.imageURL ?? ""
        return patchComment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateReportText(button: UIButton, report: Bool) {
        
        let reportIcon = Icon.ReportFlag.attributedTextWithStyle(style: reportTextStyle)
        let reportTitle = reportTextStyle.attributedString(withText: (report ? Strings.discussionUnreport : Strings.discussionReport ))
        
        let buttonTitle = NSAttributedString.joinInNaturalLayout(attributedStrings: [reportIcon, reportTitle])
        button.setAttributedTitle(buttonTitle, for: .normal)
        
        button.snp.remakeConstraints { make in
            make.top.equalTo(contentView).offset(StandardVerticalMargin)
            make.width.equalTo(buttonTitle.singleLineWidth() + StandardHorizontalMargin)
            make.trailing.equalTo(contentView).offset(-2*StandardHorizontalMargin)
        }
        
        button.accessibilityHint = report ? Strings.Accessibility.discussionUnreportHint : Strings.Accessibility.discussionReportHint
    }
    
    func setAccessiblity(commentCount : String?) {
        var accessibilityString = ""
        let sentenceSeparator = ", "
        
        let body = bodyTextView.attributedText.string
        accessibilityString.append(body + sentenceSeparator)
            
        if let date = dateLabel.text {
            accessibilityString.append(Strings.Accessibility.discussionPostedOn(date: date) + sentenceSeparator)
        }
        
        if let author = authorNameLabel.text {
            accessibilityString.append(Strings.accessibilityBy + " " + author + sentenceSeparator)
        }
        
        if let endorsed = endorsedLabel.text, !endorsedLabel.isHidden {
            accessibilityString.append(endorsed + sentenceSeparator)
        }
        
        if let comments = commentCount {
            accessibilityString.append(comments)
            commentCountOrReportIconButton.isAccessibilityElement = false
        }
        
        accessibilityLabel = accessibilityString
        
        if let authorName = authorNameLabel.text {
            self.authorButton.accessibilityLabel = authorName
            self.authorButton.accessibilityHint = Strings.accessibilityShowUserProfileHint
        }
    }
}

protocol DiscussionCommentsViewControllerDelegate: AnyObject {
    
    func discussionCommentsView(controller  : DiscussionCommentsViewController, updatedComment comment: DiscussionComment)
}

class DiscussionCommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DiscussionNewCommentViewControllerDelegate, InterfaceOrientationOverriding {
    
    typealias Environment = DataManagerProvider & NetworkManagerProvider & OEXRouterProvider & OEXAnalyticsProvider & OEXStylesProvider & OEXConfigProvider
    
    private enum TableSection : Int {
        case Response = 0
        case Comments = 1
    }
    
    private let identifierCommentCell = "CommentCell"
    fileprivate let environment: Environment
    private let courseID: String
    private let discussionManager : DiscussionDataManager
    private var loadController : LoadStateViewController
    private let contentView = UIView()
    private let addCommentButton = UIButton(type: .system)
    fileprivate var tableView: UITableView!
    fileprivate var comments : [DiscussionComment]  = []
    private var responseItem: DiscussionComment?
    weak var delegate: DiscussionCommentsViewControllerDelegate?
    var profileFeed: Feed<UserProfile>?
    var tempComment: DiscussionComment? // This will be used for injecting user info to added comment
    
    //Since didSet doesn't get called from within initialization context, we need to set it with another variable.
    private var commentsClosed : Bool = false {
        didSet {
            let styles = OEXStyles.shared()
            
            addCommentButton.backgroundColor = commentsClosed ? styles.neutralBase() : styles.secondaryBaseColor()

            let icon = commentsClosed ? Icon.Closed : Icon.Create

            let createImage = icon.imageWithFontSize(size: 14).image(with: environment.styles.neutralWhiteT())
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = createImage
            let imageOffsetY: CGFloat = -3.0
            if let image = imageAttachment.image {
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: image.size.width, height: image.size.height)
            }
            let attributedImageString = NSAttributedString(attachment: imageAttachment)
            let style = OEXTextStyle(weight : .semiBold, size: .base, color: environment.styles.neutralWhiteT())
            let attributedStrings = [
                attributedImageString,
                NSAttributedString(string: "\u{00a0}"),
                style.attributedString(withText: Strings.addComment)
            ]
            let buttonTitle = NSAttributedString.joinInNaturalLayout(attributedStrings: attributedStrings)
            
            addCommentButton.setAttributedTitle(buttonTitle, for: .normal)
            addCommentButton.isEnabled = !commentsClosed
            
            if (!commentsClosed) {
                addCommentButton.oex_addAction({[weak self] (action : AnyObject!) -> Void in
                    if let owner = self {
                        
                        guard let thread = owner.thread, let responseItem = owner.responseItem else { return }
                        
                        owner.environment.router?.showDiscussionNewCommentFromController(controller: owner, courseID: owner.courseID, thread: thread, context: .Comment(responseItem))
                    }
                    }, for: UIControl.Event.touchUpInside)
            }
        }
    }

    var paginationController : PaginationController<DiscussionComment>?
    
    //Only used to set commentsClosed out of initialization context
    //TODO: Get rid of this variable when Swift improves
    private var closed : Bool = false
    private var thread: DiscussionThread?
    private var isDiscussionBlackedOut: Bool
    private var threadID: String?
    var commentID: String?
    
    init(environment: Environment, courseID : String, isDiscussionBlackedOut: Bool = false) {
        self.courseID = courseID
        self.environment = environment
        self.discussionManager = self.environment.dataManager.courseDataManager.discussionManagerForCourseWithID(courseID: self.courseID)
        self.isDiscussionBlackedOut = isDiscussionBlackedOut
        self.loadController = LoadStateViewController()
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(environment: Environment, courseID : String, responseItem: DiscussionComment, closed : Bool, thread: DiscussionThread?, isDiscussionBlackedOut: Bool = false) {
        self.init(environment: environment, courseID: courseID, isDiscussionBlackedOut: isDiscussionBlackedOut)
        self.responseItem = responseItem
        self.thread = thread
        self.closed = closed
    }
    
    convenience init(environment: Environment, courseID : String, commentID: String, threadID: String) {
        self.init(environment: environment, courseID: courseID)
        self.commentID = commentID
        self.threadID = threadID
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(DiscussionCommentCell.classForCoder(), forCellReuseIdentifier: identifierCommentCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        addSubviews()
        setStyles()
        setConstraints()
        
        loadController.setupInController(controller: self, contentView: self.contentView)
        
        self.commentsClosed = self.closed
        
        if responseItem != nil {
            initializeViewContent()
        }
        else if thread == nil {
            // In deep linking, we need to load thread and responseItem with their Ids.
            loadThread()
        }
        else {
            loadDiscussionResponse()
        }

        setAccessibilityIdentifiers()
    }
    
    private func initializeViewContent() {
        initializePaginator()
        loadContent()
        setupProfileLoader()
    }

    private func setAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "DiscussionCommentsViewController:view"
        contentView.accessibilityIdentifier = "DiscussionCommentsViewController:content-view"
        addCommentButton.accessibilityIdentifier = "DiscussionCommentsViewController:add-comment-button"
        tableView.accessibilityIdentifier = "DiscussionCommentsViewController:table-view"
    }

    private func loadThread() {
        guard let threadID = threadID else { return }

        let apiRequest = DiscussionAPI.readThread(read: true, threadID: threadID)
        environment.networkManager.taskForRequest(apiRequest) {[weak self] result in
            if result.response?.httpStatusCode.is2xx ?? false {
                if let thread = result.data {
                    self?.thread = thread
                    self?.loadDiscussionResponse()
                }
            }
            else {
                self?.loadController.state = LoadState.failed(error: result.error)
            }
        }
    }
    
    private func loadDiscussionResponse() {
        guard let commentID = commentID else { return }
        
        let apiRequest =  DiscussionAPI.getResponse(responseID: commentID)
        environment.networkManager.taskForRequest(apiRequest) {[weak self] result in
            if result.response?.httpStatusCode.is2xx ?? false {
                if let response = result.data {
                    self?.responseItem = response
                    self?.initializeViewContent()
                }
            }
            else {
                self?.loadController.state = LoadState.failed(error: result.error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logScreenEvent()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    private func logScreenEvent() {
        environment.analytics.trackDiscussionScreen(withName: AnalyticsScreenName.ViewResponseComments, courseId: courseID, value: thread?.title, threadId: responseItem?.threadID, topicId: nil, responseID: responseItem?.commentID, author: responseItem?.author)
    }
    
    func addSubviews() {
        view.addSubview(contentView)
        contentView.addSubview(tableView)
        view.addSubview(addCommentButton)
    }
    
    func setStyles() {
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.applyStandardSeparatorInsets()
        tableView.backgroundColor = OEXStyles.shared().neutralXLight()
        tableView.contentInset = UIEdgeInsets.init(top: 10.0, left: 0, bottom: 0, right: 0)
        tableView.clipsToBounds = true
        
        self.navigationItem.title = Strings.comments
        view.backgroundColor = OEXStyles.shared().neutralXLight()
        self.contentView.backgroundColor = OEXStyles.shared().neutralXLight()
        
        addCommentButton.contentVerticalAlignment = .center
        
        addCommentButton.backgroundColor = environment.styles.primaryDarkColor()
        addCommentButton.alpha = isDiscussionBlackedOut || commentsClosed ? 0.5 : 1.0
        addCommentButton.isEnabled = !(isDiscussionBlackedOut || commentsClosed)
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func toggleAddCommentButton(enabled: Bool){
        addCommentButton.backgroundColor = enabled ? environment.styles.primaryDarkColor() : environment.styles.neutralBase()
        addCommentButton.isEnabled = enabled
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(safeLeading)
            make.top.equalTo(safeTop)
            make.trailing.equalTo(safeTrailing)
            make.bottom.equalTo(addCommentButton.snp.top)
        }
        
        addCommentButton.snp.makeConstraints{ make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(OEXStyles.shared().standardFooterHeight)
            make.bottom.equalTo(safeBottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.top.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    private func initializePaginator() {
    
        guard let responseItem = responseItem else { return }
        
        precondition(!responseItem.commentID.isEmpty, "Shouldn't be showing comments for empty commentID")
        
        let paginator = WrappedPaginator(networkManager: self.environment.networkManager) {[weak self] page in
            return DiscussionAPI.getComments(environment: self?.environment.router?.environment, commentID: responseItem.commentID, pageNumber: page)
        }
        
        paginationController = PaginationController(paginator: paginator, tableView: self.tableView)
    }
    
    private func loadContent() {
        paginationController?.stream.listen(self, success:
            { [weak self] comments in
                self?.loadController.state = .Loaded
                self?.comments = comments
                self?.tableView.reloadData()
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: nil)
            }, failure: { [weak self] (error) -> Void in
                self?.loadController.state = LoadState.failed(error: error)
        })
        
        paginationController?.loadMore()
    }
    
    private func showAddedComment(comment: DiscussionComment) {
        comments.append(comment)
        tableView.reloadData()
        
        let indexPath = IndexPath(row: comments.count - 1, section: TableSection.Comments.rawValue)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    private func setupProfileLoader() {
        guard environment.config.profilesEnabled else { return }
        profileFeed = self.environment.dataManager.userProfileManager.feedForCurrentUser()
        profileFeed?.output.listen(self,  success: { [weak self] profile in
            if var comment = self?.tempComment {
                comment.hasProfileImage = !((profile.imageURL?.isEmpty) ?? true )
                comment.imageURL = profile.imageURL ?? ""
                self?.showAddedComment(comment: comment)
                self?.tempComment = nil
            }
            }, failure : { _ in
                Logger.logError("Profiles", "Unable to fetch profile")
        })
    }
    
    // MARK - tableview delegate methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue:section) {
        case .some(.Response): return 1
        case .some(.Comments): return comments.count
        case .none:
            assert(true, "Unexepcted table section")
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCommentCell, for: indexPath) as! DiscussionCommentCell
        
        switch TableSection(rawValue: indexPath.section) {
        case .some(.Response):
            guard let responseItem = responseItem, let thread = thread else { return UITableViewCell() }
                cell.useResponse(response: responseItem, viewController: self)
                DiscussionHelper.updateEndorsedTitle(thread: thread, label: cell.endorsedLabel, textStyle: cell.endorsedTextStyle)
            return cell
        case .some(.Comments):
            cell.useComment(comment: comments[indexPath.row], inViewController: self, index: indexPath.row)
            return cell
        case .none:
            assert(false, "Unknown table section")
            return UITableViewCell()
        }
    }
    
    // MARK- DiscussionNewCommentViewControllerDelegate method 
    
    func newCommentController(controller: DiscussionNewCommentViewController, addedComment comment: DiscussionComment) {
        responseItem?.childCount += 1
        
        if !(paginationController?.hasNext ?? false) {
            tempComment = comment
            profileFeed?.refresh()
        }
        if let responseItem = responseItem {
            delegate?.discussionCommentsView(controller: self, updatedComment: responseItem)
        }
        showOverlay(withMessage: Strings.discussionCommentPosted)
    }
}

// Testing only
extension DiscussionCommentsViewController {
    var t_loaded : OEXStream<()> {
        return self.paginationController!.stream.map {_ in
            return
        }
    }
}
