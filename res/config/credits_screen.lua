local apputil = require "apputil"

function data()
    return {
        items = {

            { type = "HEADER1", text = "Transport Fever 2" },
            { type = "NAME", text = "Copyright © 2008-2024 Urban Games GmbH, Switzerland \nwww.transportfever2.com\n All rights reserved." },
            

            --==================================================================================
            { type = "HEADER1", text = "Urban Games"},
            --==================================================================================

            { type = "HEADER2", text = _("Project lead") },
            { type = "NAME", text = "Basil Weber" },

            { type = "HEADER2", text = _("Lead programmer") },
            { type = "NAME", text = "Urban Weber" },
            { type = "NAME", text = "Filippo Leonardi" },

            { type = "HEADER2", text = _("Lead artists") },
            { type = "NAME", text = "Stephan Schweizer" },
            { type = "NAME", text = "Daniel Guimard" },

            { type = "HEADER2", text = _("Head of development") },
            { type = "NAME", text = "Thomas Oskam" },

            { type = "HEADER2", text = _("Game design") },
            { type = "NAME", text = "Basil Weber" },
            { type = "NAME", text = "Tom Schrettl" },
            { type = "NAME", text = "Matthias Gürtler" },
            { type = "NAME", text = "Marlon José Stadler" },

            { type = "HEADER2", text = _("Production") },
            { type = "NAME", text = "Thomas Bürkli" },
            { type = "NAME", text = "Matthias Gürtler" },
            { type = "NAME", text = "Marlon José Stadler" },
            { type = "NAME", text = "Martin Hodler" },

            { type = "HEADER2", text = _("Programming") },
            { type = "NAME", text = "Urban Weber" },
            { type = "NAME", text = "Filippo Leonardi" },
            { type = "NAME", text = "Lorenzo Luisoni" },
            { type = "NAME", text = "Nils Kübler" },
            { type = "NAME", text = "Christian Regg" },
            { type = "NAME", text = "Stefan Blumer" },
            { type = "NAME", text = "Lukas Frischknecht" },
            { type = "NAME", text = "Uladzimir Kokarau" },
            { type = "NAME", text = "Magdalena Ott" },
            { type = "NAME", text = "Nihat Isik" },
            { type = "NAME", text = "Qais El Okaili" },
            { type = "NAME", text = "Christian Käser" },

            { type = "HEADER2", text = _("Art") },
            { type = "NAME", text = "Daniel Guimard" },
            { type = "NAME", text = "Stephan Schweizer" },
            { type = "NAME", text = "Manu Mikael Oehler" },
            { type = "NAME", text = "Camille Vedel" },
            { type = "NAME", text = "Karl Heinrich Klein" },
            { type = "NAME", text = "Nadja Rauer" },
            { type = "NAME", text = "Jeanne Pamer" },
            { type = "NAME", text = "Tobias Rohrwacher" },

            { type = "HEADER2", text = _("Campaign design") },
            { type = "NAME", text = "Tom Schrettl" },
            { type = "NAME", text = "Susi Stühlinger" },

            { type = "HEADER2", text = _("Community management") },
            { type = "NAME", text = "Matthias Gürtler" },
            { type = "NAME", text = "Basil Weber" },
            { type = "NAME", text = "Tom Schrettl" },
            { type = "NAME", text = "Jeanina Cepan" },
            { type = "NAME", text = "Marlon José Stadler" },
            { type = "NAME", text = "Martin Hodler" },

            { type = "HEADER2", text = _("Infrastructure") },
            { type = "NAME", text = "Sergio Lindo Mansilla" },
            { type = "NAME", text = "Marlon José Stadler" },

            { type = "HEADER2", text = _("Administration") },
            { type = "NAME", text = "Cleopatra Bollinger" },

            { type = "HEADER2", text = _("Interns") },
            { type = "NAME", text = "Oliver Rietmann" },
            { type = "NAME", text = "Nils Dobberstein" },

            --==================================================================================
            { type = "HEADER1", text = _("Contributors") },
            --==================================================================================

            { type = "HEADER2", text = _("Art") },
            { type = "NAME", text = "TGR Studio" },
            { type = "NAME", text = "Pavel Sviridov (CEO)" },
            { type = "NAME", text = "Alexey Stankevich (Lead 3D artist)" },
            { type = "NAME", text = "Akubekov Alexey (3D artist)" },
            { type = "NAME", text = "Poberezhnyuk Igor (3D artist)" },
            { type = "NAME", text = "Polovinkin Igor (3D artist)" },
            { type = "NAME", text = "Vysotskaya Christina (Technical support)" },
            { type = "NAME", text = "VRBN Studios" },

            { type = "HEADER2", text = _("Music") },
            { type = "NAME", text = "David Langhard" },

            { type = "HEADER2", text = _("Sound effects") },
            { type = "NAME", text = "Allister Brimble" },
            { type = "NAME", text = "Anthony Putson" },

            { type = "HEADER2", text = _("Voice-over") },
            { type = "NAME", text = "Toneworx" },

            { type = "HEADER2", text = _("Key visuals") },
            { type = "NAME", text = "Colorbleed" },

            { type = "HEADER2", text = _("Localization") },
            { type = "NAME", text = "Lionbridge" },
            { type = "NAME", text = "Jorge Andrés Huélamo" },
            { type = "NAME", text = "Robert H. Ćwik" },
            { type = "NAME", text = "SiphaCraft" },

            { type = "HEADER2", text = _("Quality assurance") },
            { type = "NAME", text = "Player Research" },

            --==================================================================================
            { type = "HEADER1", text = "Good Shepherd Entertainment", filterOut = { "Console" } },
            --==================================================================================

            { type = "HEADER2", text = _("Team"), filterOut = { "Console" } },
            { type = "NAME", text = "Vieko Franetovic", filterOut = { "Console" } },
            { type = "NAME", text = "Vernon Vrolijk", filterOut = { "Console" } },
            { type = "NAME", text = "Sjoerd Geurts", filterOut = { "Console" } },
            { type = "NAME", text = "Randy Greenback", filterOut = { "Console" } },
            { type = "NAME", text = "Paul Hanraets", filterOut = { "Console" } },
            { type = "NAME", text = "Mike Wilson", filterOut = { "Console" } },
            { type = "NAME", text = "Michiel Verheijdt", filterOut = { "Console" } },
            { type = "NAME", text = "Justin Burnham", filterOut = { "Console" } },
            { type = "NAME", text = "Jürgen Stirnweis", filterOut = { "Console" } },
            { type = "NAME", text = "Jenesee Grey", filterOut = { "Console" } },
            { type = "NAME", text = "Harry Miller", filterOut = { "Console" } },
            { type = "NAME", text = "Brian Grigsby", filterOut = { "Console" } },
            { type = "NAME", text = "Ben Newhouse", filterOut = { "Console" } },
            { type = "NAME", text = "Ben Andac", filterOut = { "Console" } },
            { type = "NAME", text = "Anne-Christine Gasc", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Cosmocover"), filterOut = { "Console" } },
            { type = "NAME", text = "Tobias Kammer", filterOut = { "Console" } },
            { type = "NAME", text = "Salima Bessahraoui", filterOut = { "Console" } },
            { type = "NAME", text = "Pierre-Louis Barbier", filterOut = { "Console" } },
            { type = "NAME", text = "Nyssa Woznicki", filterOut = { "Console" } },
            { type = "NAME", text = "John Tyrrell", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Indigo Pearl"), filterOut = { "Console" } },
            { type = "NAME", text = "Robbie Paterson", filterOut = { "Console" } },
            { type = "NAME", text = "Anita Wong", filterOut = { "Console" } },
            { type = "NAME", text = "Alex Holt-Kulapalan", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Marchsreiter"), filterOut = { "Console" } },
            { type = "NAME", text = "Robin Sickert", filterOut = { "Console" } },
            { type = "NAME", text = "Dieter Marchsreiter", filterOut = { "Console" } },
            { type = "NAME", text = "Aleksandra Ptasinska", filterOut = { "Console" } },

            --==================================================================================
            { type = "HEADER1", text = "astragon Entertainment GmbH", filterOut = { "Console" } },
            --==================================================================================

            { type = "HEADER2", text = _("Management"), filterOut = { "Console" } },
            { type = "NAME", text = "Julia Pfiffer", filterOut = { "Console" } },
            { type = "NAME", text = "Tim Schmitz", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Marketing"), filterOut = { "Console" } },
            { type = "NAME", text = "Gennaro Grippo", filterOut = { "Console" } },
            { type = "NAME", text = "Pierre Friedrichsmeier", filterOut = { "Console" } },
            { type = "NAME", text = "Yvonne Lukanowski", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Marketing Assistant"), filterOut = { "Console" } },
            { type = "NAME", text = "Barbara Gerbracht", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Head of PR & Community Management"), filterOut = { "Console" } },
            { type = "NAME", text = "Daniella Wallau", filterOut = { "Console" } },

            { type = "HEADER2", text = _("PR & Community Management"), filterOut = { "Console" } },
            { type = "NAME", text = "Carsten Höh", filterOut = { "Console" } },

            { type = "HEADER2", text = _("PR Assistant"), filterOut = { "Console" } },
            { type = "NAME", text = "Maik Flade", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Head of Product Management"), filterOut = { "Console" } },
            { type = "NAME", text = "Reinhard Vree", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Product Management"), filterOut = { "Console" } },
            { type = "NAME", text = "Judith Lücke", filterOut = { "Console" } },
            { type = "NAME", text = "Jens Brauckhoff", filterOut = { "Console" } },

            { type = "HEADER2", text = _("Product Management Assistant"), filterOut = { "Console" } },
            { type = "NAME", text = "Nils Rieger", filterOut = { "Console" } },
            { type = "NAME", text = "Miriam Kaisers", filterOut = { "Console" } },
            { type = "NAME", text = "Daniel Hartmann", filterOut = { "Console" } },

            --==================================================================================
            { type = "HEADER1", text = "Nacon", filterOut = { "Desktop" } },
            --==================================================================================

            { type = "HEADER2", text = _("Head of Publishing"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Benoît Clerc", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Software Assistant"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Cassandra Bertho", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Production Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Jérôme Antona", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Game Producer"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Valentin Magry", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("QA Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Olivier Garin", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Functional QA Leads"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Thibaud Lorotte", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Compliance Analyst"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Régis Pouilly", filterOut = { "Desktop" } },
            { type = "NAME", text = "Sandra Fazio", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Head of Release & Certification"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Clément Taisne", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Release Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Edouard Lavenue", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Release Manager Assistant"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Florent Louis", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Certification Assistant"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Margot Chemin", filterOut = { "Desktop" } },
            { type = "NAME", text = "Esteban De La Oliva", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Head of Marketing"), filterOut = { "Desktop" } },
            { type = "NAME", text = "David Talmat", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Software Product Managers"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Raphaël Isnard", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Graphic Designers"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Thomas Lelong", filterOut = { "Desktop" } },
            { type = "NAME", text = "Steffi Girinon", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Head of Video Department"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Fabrice Bermudez", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Motion Designers"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Benjamin Corbel", filterOut = { "Desktop" } },
            { type = "NAME", text = "Florian Truffin", filterOut = { "Desktop" } },
            { type = "NAME", text = "Axel Mortaigne", filterOut = { "Desktop" } },
            { type = "NAME", text = "Chloé Laurent", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Lead Community Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Cryss Leonhart", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Community Managers"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Benjamin \"Lugia\" Vogt", filterOut = { "Desktop" } },
            { type = "NAME", text = "Olivier Cheqri", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("PR Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Marjorie Roy", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("PR and Communication Specialists"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Hama Doucouré", filterOut = { "Desktop" } },
            { type = "NAME", text = "Lou Fortin", filterOut = { "Desktop" } },
            { type = "NAME", text = "Rémi Demolière", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Head of Sales & E-commerce"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Sébastien Pellicano", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Digital Sales Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Grégoire Charlier", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Digital Distribution Account Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Claire Gelin", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Game Data Analyst"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Régis Fontenay", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Data Engineer"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Guillaume Paris", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("CRM Project Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Isis Ansart", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Web Project Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Nicolas Ameloot", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Web Technical Lead"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Marc-Antoine Meurisse", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Web Developer"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Mallaury Alaer", filterOut = { "Desktop" } },

            --==================================================================================
            { type = "HEADER1", text = "PTW", filterOut = { "Desktop" } },
            --==================================================================================

            { type = "HEADER2", text = _("COO"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Sijo Jose", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Senior QA Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Veerendra Naik", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Project Manager"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Praveen Vaman", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Compliance QA Lead"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Harsh Singh", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Functional QA Lead"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Aditya Yadav", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Compliance QA"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Amit Kumar", filterOut = { "Desktop" } },
            { type = "NAME", text = "Akshay Ishwar", filterOut = { "Desktop" } },
            { type = "NAME", text = "Praveen M R", filterOut = { "Desktop" } },
            { type = "NAME", text = "Ayush Thakur", filterOut = { "Desktop" } },
            { type = "NAME", text = "Bharath Mahadev", filterOut = { "Desktop" } },
            { type = "NAME", text = "Anand Kumar", filterOut = { "Desktop" } },
            { type = "NAME", text = "Suvin Alexandre", filterOut = { "Desktop" } },
            { type = "NAME", text = "Abhishek Ramesh", filterOut = { "Desktop" } },
            { type = "NAME", text = "Rohit M", filterOut = { "Desktop" } },
            { type = "NAME", text = "Syed Mansoor", filterOut = { "Desktop" } },
            { type = "NAME", text = "Vikas Krishna P", filterOut = { "Desktop" } },

            { type = "HEADER2", text = _("Functional QA"), filterOut = { "Desktop" } },
            { type = "NAME", text = "Pravarthan HR", filterOut = { "Desktop" } },
            { type = "NAME", text = "Praveen R", filterOut = { "Desktop" } },
            { type = "NAME", text = "Are Chaitanyakrishna", filterOut = { "Desktop" } },
            { type = "NAME", text = "Rajeev T", filterOut = { "Desktop" } },

            --==================================================================================
            { type = "HEADER1", text = "Third Party Libraries" },
            --==================================================================================
            
            { filterOut = {"Console"}, type = "HEADER2", text = "Autodesk® FBX®" },
            { filterOut = {"Console"}, type = "LICENSE", text = [[
This software contains Autodesk® FBX® code developed by Autodesk, Inc. Copyright 2019 Autodesk, Inc. All rights, reserved. Such code is provided “as is” and Autodesk, Inc. disclaims any and all warranties, whether express or implied, including without limitation the implied warranties of merchantability, fitness for a particular purpose or non-infringement of third  party rights. In no event shall Autodesk, Inc. be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of such code.
            ]] },
            
            { type = "HEADER2", text = "Boost" },
            { type = "LICENSE", text = [[
Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization obtaining a copy of the software and accompanying documentation covered by this license (the "Software") to use, reproduce, display, distribute, execute, and transmit the Software, and to prepare derivative works of the Software, and to permit third-parties to whom the Software is furnished to do so, all subject to the following:
                    
The copyright notices in the Software and this entire statement, including the above license grant, this restriction and the following disclaimer, must be included in all copies of the Software, in whole or in part, and all derivative works of the Software, unless such copies or derivative works are solely in the form of machine-executable object code  generated by a source language processor.
                
THE SOFTWARE IS PROVIDED  "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
            ]] },
            
            { type = "HEADER2", text = "Bullet Physics Library" },
            { type = "LICENSE", text = "Bullet Continuous Collision Detection and Physics Library\nCopyright © 2003-2011 Erwin Coumans\nLicensed under zlib-License." },
            
            { type = "HEADER2", text = "{fmt}" },
            { type = "LICENSE", text = "Copyright © 2012 - present, Victor Zverovich\nLicensed under MIT-License." },
            
            { filterOut = {"PS"}, type = "HEADER2", text = "freealut" },
            { filterOut = {"PS"}, type = "LICENSE", text = "Licensed under GNU Library General Public License." },
            
            { type = "HEADER2", text = "FreeType Project" },
            { type = "LICENSE", text = "Portions of this software are copyright © 2010 The FreeType Project (www.freetype.org).\nAll rights reserved." },
            
            { type = "HEADER2", text = "FTGL" },
            { type = "LICENSE", text = [[
Copyright © 2001-2004 Henry Maddocks <ftgl@opengl.geek.nz>
Copyright © 2008 Sam Hocevar <sam@zoy.org>
Copyright © 2008 Sean Morrison <learner@brlcad.org>
Licensed under MIT-License.
            ]] },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "GLEW" },
            { filterOut = {"Console"}, type = "LICENSE", text = [[
The OpenGL Extension Wrangler Library
Copyright © 2002-2007, Milan Ikits <milan ikits[]ieee org>
Copyright © 2002-2007, Marcelo E. Magallon <mmagallo[]debian org>
Copyright © 2002, Lev Povalahev
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* The name of the author may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },
            
            { type = "HEADER2", text = "GLI" },
            { type = "LICENSE", text = "Copyright © 2010-2020 G-Truc Creation\nLicensed under MIT-License." },
            
            { type = "HEADER2", text = "GLM" },
            { type = "LICENSE", text = "Copyright © 2005 G-Truc Creation\nLicensed under MIT-License." },
            
            { type = "HEADER2", text = "GLU" },
            { type = "LICENSE", text = [[
Copyright © 1991-2000 Silicon Graphics, Inc.
All Rights Reserved.

SGI Free Software License B - Version 2.0 - September 18, 2008
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice including the dates of first publication and either this permission notice or a reference to 
http://oss.sgi.com/projects/FreeB/ 
shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL SILICON GRAPHICS, INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of Silicon Graphics, Inc. shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization from Silicon Graphics, Inc.
            ]] },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "Google Breakpad" },
            { filterOut = {"Console"}, type = "LICENSE", text = [[
Copyright © 2006 Google Inc.
All rights reserved.
                
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Google Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
                
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },
            
            { type = "HEADER2", text = "libogg" },
            { type = "LICENSE", text = [[
Copyright © 2002 Xiph.org Foundation
                              
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Xiph.org Foundation nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
                
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },

            { type = "HEADER2", text = "libvorbis" },
            { type = "LICENSE", text = [[
Copyright © 2002-2020 Xiph.org Foundation
                              
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Xiph.org Foundation nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
                
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "LLVM Compiler Infrastructure" },

            { filterOut = {"Console"}, type = "LICENSE", text = [[
Copyright © 2003-2018 University of Illinois at Urbana-Champaign.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the LLVM Team, University of Illinois at Urbana-Champaign, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
    
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },

            { type = "HEADER2", text = "lodepng" },
            { type = "LICENSE", text = "Copyright © 2005-2018 Lode Vandevenne\nLicensed under zlib-License." },

            { type = "HEADER2", text = "parallel-hashmap" },
            { type = "LICENSE", text = [[
https://github.com/greg7mdp/parallel-hashmap/

Apache License Version 2.0, January 2004 (https://www.apache.org/licenses/)
			]] },
            
            { type = "HEADER2", text = "Loki" },
            { type = "LICENSE", text = "Copyright © 2001 Andrei Alexandrescu\nLicensed under MIT-License." },
            
            { type = "HEADER2", text = "LTGA" },
            { type = "LICENSE", text = [[
Copyright © 1999-2002 Lev Povalahev

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.
                            
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]] },
            
            { type = "HEADER2", text = "Lua" },
            { type = "LICENSE", text = "Copyright © 1994–2021 Lua.org, PUC-Rio\nLicensed under MIT-License." },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "Lua debugger" },
            { filterOut = {"Console"}, type = "LICENSE", text = "Copyright © 2016 Scott Lembcke and Howling Moon Software\nLicensed under MIT-License." },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "LunarG" },
            { filterOut = {"Console"}, type = "LICENSE", text = [[
Copyright © 2016-2020 LunarG Inc.
  
The Vulkan SDK is comprised of 100% open source components. The majority of the materials are MIT or Apache 2.0 licenses. The Vulkan SDK licensing registry (found at vulkan.lunarg.com) discloses all components in the SDK and their corresponding open source license.

ALL INFORMATION HERE IS PROVIDED "AS IS." LUNARG MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, WITH REGARD TO THIS LIST OR ITSACCURACY OR COMPLETENESS, OR WITH RESPECT TO ANY RESULTS TO BE OBTAINED FROM USE OR DISTRIBUTION OF THE LIST. BY USING OR DISTRIBUTING THIS LIST, YOU AGREE THAT IN NO EVENT SHALL LUNARG BE HELD LIABLE FOR ANY DAMAGES WHATSOEVER RESULTING FROM ANY USE OR DISTRIBUTION OF THIS LIST, INCLUDING, WITHOUT LIMITATION, ANY SPECIAL, CONSEQUENTIAL, INCIDENTAL OR OTHER DIRECT OR INDIRECT DAMAGES.
            ]] },

            { type = "HEADER2", text = "LZ4" },
            { type = "LICENSE", text = "Copyright © 2011-2020 Yann Collet. All rights reserved.\nLicensed under BSD 2-Clause License." },

            { filterOut = {"Console", "Windows", "Linux"}, type = "HEADER2", text = "MoltenVK" },
            { filterOut = {"Console", "Windows", "Linux"}, type = "LICENSE", text = [[
Copyright © 2015-2022 The Brenwill Workshop Ltd. (http://www.brenwill.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
            ]] },

            { filterOut = {"Console"}, type = "HEADER2", text = "NVIDIA Nsight Aftermath SDK" },
            { filterOut = {"Console"}, type = "LICENSE", text = "Copyright © 2017-2020, NVIDIA CORPORATION. All rights reserved.\nThis software contains source code provided by NVIDIA Corporation." },
            
            { filterOut = {"Console"}, type = "HEADER2", text = "nvtt" },
            { filterOut = {"Console"}, type = "LICENSE", text = [[
Copyright © 2007-2009 NVIDIA Corporation
Copyright © 2009-2020 Ignacio Castaño
Licensed under MIT-License.
            ]] },
           
            { filterOut = {"PS"}, type = "HEADER2", text = "OpenAL Soft" },
            { filterOut = {"PS"}, type = "LICENSE", text = "Licensed under GNU Library General Public License." },
            
            { type = "HEADER2", text = "SDL" },
            { type = "LICENSE", text = "Licensed under zlib-License." },
           
            { type = "HEADER2", text = "sol" },
            { type = "LICENSE", text = "Copyright © 2013-2018 Rapptz, ThePhD and contributors\nLicensed under MIT-License." },
            
            { type = "HEADER2", text = "Terminal 26" },
            { type = "LICENSE", text = "Additional Design: Terminal 26 - http://www.terminal26.de" },
            
            { type = "HEADER2", text = "toojpeg" },
            { type = "LICENSE", text = "Copyright © 2011-2016 Stephan Brumme\nLicensed under zlib-License." },

            { type = "HEADER2", text = "Vulkan Memory Allocator" },
            { type = "LICENSE", text = "Copyright © 2017-2022 Advanced Micro Devices, Inc. All rights reserved.\nLicensed under MIT-License." },
           
            { type = "HEADER2", text = "xxHash" },
            { type = "LICENSE", text = "Copyright © 2012-2014 Yann Collet. All rights reserved.\nLicensed under BSD 2-Clause License." },
           
            { type = "HEADER2", text = "Yusuke Kamiyamane" },
            { type = "LICENSE", text = "Some Icons are Copyright © Yusuke Kamiyamane\nhttp://p.yusukekamiyamane.com/\nAll rights reserved." },
           
            { type = "HEADER2", text = "zlib" },
            { type = "LICENSE", text = "Licensed under zlib-License." },
           
            { type = "HEADER2", text = "zstd" },
            { type = "LICENSE", text =  [[
Copyright © 2016-present, Facebook, Inc. 
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name Facebook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
    
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
            ]]  },
           
            

            { type = "HEADER1", text = "License texts" },
            
            { type = "HEADER2", text = "BSD 2-Clause License" },
            { type = "LICENSE", text = [[
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
            ]] },

            { type = "HEADER2", text = "GNU Library General Public License - Version 2 - June 1991" },
            { type = "LICENSE", text = [[
This library is free software; you can redistribute it and/or modify it under the terms of the GNU Library General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License for more details.

You should have received a copy of the GNU Library General Public License along with this library; if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
            ]] },

            { type = "HEADER2", text = "MIT-License" },
            { type = "LICENSE", text = [[
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--- Optional exception to the license ---

As an exception, if, as a result of your compiling your source code, portions of this Software are embedded into a machine-executable object form of such source code, you may redistribute such embedded portions in such object form without including the above copyright and permission notices.
            ]] },

            { type = "HEADER2", text = "zlib-License" },
            { type = "LICENSE", text = [[
This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
            ]] },

        }
    }
end
