import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  // Add AppBar here
        backgroundColor: Colors.white,
        elevation: 0,  // Remove shadow for a clean look
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Close the Terms and Conditions Page
          },
        ),
        title: Text(
          "Terms & Conditions", // Title for the AppBar
          style: TextStyle(color: const Color.fromARGB(255, 20, 20, 20)), // Set the title text color
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(  // SafeArea with reduced padding at the top
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 600,
              ),
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        // Terms and Conditions Text
                        Text(
                          "TERMS OF SERVICE\n"
                          "Last updated January 27, 2025\n\n"
                          "AGREEMENT TO OUR LEGAL TERMS\n"
                          "We are The fire vala (\"Company,\" \"we,\" \"us,\" \"our\"), a company registered in India at ___, _____.\n\n"
                          "We operate the website https://thefirewala.com/ (the \"Site\"), the mobile application Fire learning (the \"App\"), as well as any other related products and services that refer or link to these legal terms (the \"Legal Terms\") (collectively, the \"Services\").\n\n"
                          "You can contact us by email at ____ or by mail to ___, _____, India.\n\n"
                          "These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity (\"you\"), and The fire vala, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.\n\n"
                          "Supplemental terms and conditions or documents that may be posted on the Services from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Legal Terms at any time and for any reason. We will alert you about any changes by updating the \"Last updated\" date of these Legal Terms, and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Legal Terms to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Legal Terms by your continued use of the Services after the date such revised Legal Terms are posted.\n\n"
                          "The Services are intended for users who are at least 18 years old. Persons under the age of 18 are not permitted to use or register for the Services.\n\n"
                          "We recommend that you print a copy of these Legal Terms for your records.\n\n"
                          "TABLE OF CONTENTS\n"
                          "01. OUR SERVICES\n"
                          "02. INTELLECTUAL PROPERTY RIGHTS\n"
                          "03. USER REPRESENTATIONS\n"
                          "04. USER REGISTRATION\n"
                          "05. PROHIBITED ACTIVITIES\n"
                          "06. USER GENERATED CONTRIBUTIONS\n"
                          "07. CONTRIBUTION LICENSE\n"
                          "08. GUIDELINES FOR REVIEWS\n"
                          "09. MOBILE APPLICATION LICENSE\n"
                          "10. THIRD-PARTY WEBSITES AND CONTENT\n"
                          "11. ADVERTISERS\n"
                          "12. SERVICES MANAGEMENT\n"
                          "13. PRIVACY POLICY\n"
                          "14. COPYRIGHT INFRINGEMENTS\n"
                          "15. TERM AND TERMINATION\n"
                          "16. MODIFICATIONS AND INTERRUPTIONS\n"
                          "17. GOVERNING LAW\n"
                          "18. DISPUTE RESOLUTION\n"
                          "19. CORRECTIONS\n"
                          "20. DISCLAIMER\n"
                          "21. LIMITATIONS OF LIABILITY\n"
                          "22. INDEMNIFICATION\n"
                          "23. USER DATA\n"
                          "24. ELECTRONIC COMMUNICATIONS, TRANSACTIONS, AND SIGNATURES\n"
                          "25. MISCELLANEOUS\n"
                          "26. CONTACT US\n\n"
                          "1. OUR SERVICES\n"
                          "The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.\n\n"
                          "2. INTELLECTUAL PROPERTY RIGHTS\n"
                          "Our intellectual property\n"
                          "We are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the \"Content\"), as well as the trademarks, service marks, and logos contained therein (the \"Marks\").\n\n"
                          "Our Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties around the world.\n\n"
                          "The Content and Marks are provided in or through the Services (\"AS IS\") for your personal, non-commercial use or internal business purpose only.\n\n"
                          "Your use of our Services\n"
                          "Subject to your compliance with these Legal Terms, including the \"PROHIBITED ACTIVITIES\" section below, we grant you a non-exclusive, non-transferable, revocable license to\n"
                          "access the Services; and\n"
                          "download or print a copy of any portion of the Content to which you have properly gained access,\n"
                          "solely for your personal, non-commercial use or internal business purpose.\n"

                          "Except as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.\n"

                          "If you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: ____. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content.\n"

                          "We reserve all rights not expressly granted to you in and to the Services, Content, and Marks.\n"

                          "Any breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately.\n"
                          "Your submissions and contributions\n"
                          "Please review this section and the \"PROHIBITED ACTIVITIES\" section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services.\n"

                          "Submissions: By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services (\"Submissions\"), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you.\n"

                          "Contributions: The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality during which you may create, submit, post, display, transmit, publish, distribute, or broadcast content and materials to us or through the Services, including but not limited to text, writings, video, audio, photographs, music, graphics, comments, reviews, rating suggestions, personal information, or other material (\"Contributions\"). Any Submission that is publicly posted shall also be treated as a Contribution.\n"

                          "You understand that Contributions may be viewable by other users of the Services and possibly through third-party websites.\n"

                          "When you post Contributions, you grant us a license (including use of your name, trademarks, and logos): By posting any Contributions, you grant us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to: use, copy, reproduce, distribute, sell, resell, publish, broadcast, retitle, store, publicly perform, publicly display, reformat, translate, excerpt (in whole or in part), and exploit your Contributions (including, without limitation, your image, name, and voice) for any purpose, commercial, advertising, or otherwise, to prepare derivative works of, or incorporate into other works, your Contributions, and to sublicense the licenses granted in this section. Our use and distribution may occur in any media formats and through any media channels.\n"

                          "This license includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide.\n\n"
 
                          "You are responsible for what you post or upload: By sending us Submissions and/or posting Contributions through any part of the Services or making Contributions accessible through the Services by linking your account through the Services to any of your social networking accounts, you:\n"
                          "confirm that you have read and agree with our \"PROHIBITED ACTIVITIES\" and will not post, send, publish, upload, or transmit through the Services any Submission nor post any Contribution that is illegal, harassing, hateful, harmful, defamatory, obscene, bullying, abusive, discriminatory, threatening to any person or group, sexually explicit, false, inaccurate, deceitful, or misleading;\n"
                          "to the extent permissible by applicable law, waive any and all moral rights to any such Submission and/or Contribution;\n"
                          "warrant that any such Submission and/or Contributions are original to you or that you have the necessary rights and licenses to submit such Submissions and/or Contributions and that you have full authority to grant us the above-mentioned rights in relation to your Submissions and/or Contributions; and\n"
                          "warrant and represent that your Submissions and/or Contributions do not constitute confidential information.\n"
                          "You are solely responsible for your Submissions and/or Contributions and you expressly agree to reimburse us for any and all losses that we may suffer because of your breach of (a) this section, (b) any third party’s intellectual property rights, or (c) applicable law.\n\n"

                          "We may remove or edit your Content: Although we have no obligation to monitor any Contributions, we shall have the right to remove or edit any Contributions at any time without notice if in our reasonable opinion we consider such Contributions harmful or in breach of these Legal Terms. If we remove or edit any such Contributions, we may also suspend or disable your account and report you to the authorities.\n\n"
                          "Copyright infringement\n"
                          "We respect the intellectual property rights of others. If you believe that any material available on or through the Services infringes upon any copyright you own or control, please immediately refer to the \"COPYRIGHT INFRINGEMENTS\" section below.\n\n"

                          "3. USER REPRESENTATIONS\n"
                          "By using the Services, you represent and warrant that: (1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Legal Terms; (4) you are not a minor in the jurisdiction in which you reside; (5) you will not access the Services through automated or non-human means, whether through a bot, script or otherwise; (6) you will not use the Services for any illegal or unauthorized purpose; and (7) your use of the Services will not violate any applicable law or regulation.\n"

                          "If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Services (or any portion thereof).\n\n"

                          "4. USER REGISTRATION\n"
                          "You may be required to register to use the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.\n\n"

                          "5. PROHIBITED ACTIVITIES\n"
                          "You may not access or use the Services for any purpose other than that for which we make the Services available. The Services may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us.\n\n"

                          "As a user of the Services, you agree not to:\n"
                          "Systematically retrieve data or other content from the Services to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.\n"
                          "Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords.\n"
                          "Circumvent, disable, or otherwise interfere with security-related features of the Services, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Services and/or the Content contained therein.\n"
                          "Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Services.\n"
                          "Use any information obtained from the Services in order to harass, abuse, or harm another person.\n"
                          "Make improper use of our support services or submit false reports of abuse or misconduct.\n"
                          "Use the Services in a manner inconsistent with any applicable laws or regulations.\n"
                          "Engage in unauthorized framing of or linking to the Services,\n"
                          "Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party’s uninterrupted use and enjoyment of the Services or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Services.\n"
                          "Engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools.\n"
                          "Delete the copyright or other proprietary rights notice from any Content.\n"
                          "Attempt to impersonate another user or person or use the username of another user.\n"
                          "Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats (gifs), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as \"spyware\" or \"passive collection mechanisms\" or \"pcms\").\n"
                          "Interfere with, disrupt, or create an undue burden on the Services or the networks or services connected to the Services.\n"
                          "Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Services to you.\n"
                          "Attempt to bypass any measures of the Services designed to prevent or restrict access to the Services, or any portion of the Services.\n"
                          "Copy or adapt the Services' software, including but not limited to Flash, PHP, HTML, JavaScript, or other code.\n"
                          "Except as permitted by applicable law, decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Services.\n"
                          "Except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Services, or use or launch any unauthorized script or other software.\n"
                          "Use a buying agent or purchasing agent to make purchases on the Services.\n"
                          "Make any unauthorized use of the Services, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses.\n"
                          "Use the Services as part of any effort to compete with us or otherwise use the Services and/or the Content for any revenue-generating endeavor or commercial enterprise.\n"
                          "Use the Services to advertise or offer to sell goods and services.\n"
                          "Sell or otherwise transfer your profile.\n\n"

                          "6. USER GENERATED CONTRIBUTIONS\n"
                          "The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on the Services, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, \"Contributions\"). Contributions may be viewable by other users of the Services and through third-party websites. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary. When you create or make available any Contributions, you thereby represent and warrant that:\n"
                          "The creation, distribution, transmission, public display, or performance, and the accessing, downloading, or copying of your Contributions do not and will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark, trade secret, or moral rights of any third party.\n"
                          "You are the creator and owner of or have the necessary licenses, rights, consents, releases, and permissions to use and to authorize us, the Services, and other users of the Services to use your Contributions in any manner contemplated by the Services and these Legal Terms.\n"
                          "You have the written consent, release, and/or permission of each and every identifiable individual person in your Contributions to use the name or likeness of each and every such identifiable individual person to enable inclusion and use of your Contributions in any manner contemplated by the Services and these Legal Terms.\n"
                          "Your Contributions are not false, inaccurate, or misleading.\n"
                          "Your Contributions are not unsolicited or unauthorized advertising, promotional materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of solicitation.\n"
                          "Your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing, libelous, slanderous, or otherwise objectionable (as determined by us).\n"
                          "Your Contributions do not ridicule, mock, disparage, intimidate, or abuse anyone.\n"
                          "Your Contributions are not used to harass or threaten (in the legal sense of those terms) any other person and to promote violence against a specific person or class of people.\n"
                          "Your Contributions do not violate any applicable law, regulation, or rule.\n"
                          "Your Contributions do not violate the privacy or publicity rights of any third party.\n"
                          "Your Contributions do not violate any applicable law concerning child pornography, or otherwise intended to protect the health or well-being of minors.\n"
                          "Your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap.\n"
                          "Your Contributions do not otherwise violate, or link to material that violates, any provision of these Legal Terms, or any applicable law or regulation.\n"
                          "Any use of the Services in violation of the foregoing violates these Legal Terms and may result in, among other things, termination or suspension of your rights to use the Services.\n\n"

                          "7. CONTRIBUTION LICENSE\n"
                          "By posting your Contributions to any part of the Services, you automatically grant, and you represent and warrant that you have the right to grant, to us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to host, use, copy, reproduce, disclose, sell, resell, publish, broadcast, retitle, archive, store, cache, publicly perform, publicly display, reformat, translate, transmit, excerpt (in whole or in part), and distribute such Contributions (including, without limitation, your image and voice) for any purpose, commercial, advertising, or otherwise, and to prepare derivative works of, or incorporate into other works, such Contributions, and grant and authorize sublicenses of the foregoing. The use and distribution may occur in any media formats and through any media channels.\n"

                          "This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions.\n"
                                                    // You can continue to add the rest of your Terms and Conditions here...
                
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}