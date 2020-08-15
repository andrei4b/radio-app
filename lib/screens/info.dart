import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despre Aplicație'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Întregul conținut al aplicației Radio Vestea Bună este protejat prin Legea drepturilor de autor, toate drepturile fiind rezervate. Orice material pe care îl copiați, tipăriți sau îl descărcați din această aplicație este oferit sub licența Radio Vestea Bună și nu poate fi folosit în scopuri comerciale. Nu aveți voie să modificați sau să ștergeți mărcile sau logourile care atestă dreptul de autor al Radio Vestea Bună.\n\nRadio Vestea Bună face tot posibilul pentru a vă oferi informații precise, corecte și actualizate pe site, dar cu toate acestea Radio Vestea Bună nu iși asumă responsabilitatea cu privire la acuratețea, corectitudinea și frecvența actualizării datelor.\n\nDeveloper: Andrei Bulzan'),
              SizedBox(
                height: 32,
              ),
              Text(
                'Politică de confidențialitate:',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Radio Vestea Bună este o aplicaţie pentru copii unde aceștia pot învăţa lucruri din Cuvântul lui Dumnezeu pe care apoi să le aplice în viaţa lor, și pot de asemenea asculta muzică bună şi potrivită pentru vârsta lor. Garantăm faptul că la Radio Vestea Bună copiii se vor afla întotdeauna într-un mediu sănătos.\nEchipa Radio Vestea Bună crede în puterea Cuvântului lui Dumnezeu şi îi încurajăm atât pe copii cât şi pe părinţii lor să intre pe aplicaţie şi să se bucure de ea.\nPe lângă faptul că vă încurajăm să intraţi pe aplicaţie, ne străduim ca să-i informăm atât pe părinţi cât şi pe copii cu privire la măsurile ce trebuiesc luate atunci când descarcă aplicaţii pe telefonul lor sau pe alte dispozitive.\nÎntâi de toate, copiii trebuie să ceară permisiunea părinţilor înainte să furnizeze orice informaţie personală pe site-urile de pe Internet sau pe aplicaţiile online iar părinţii trebuie să comunice copiilor ce restricţii au aceştia în a face cunoscute detaliile personale, necunoscuţilor.\n\nLa Radio Vestea Bună, politica noastră este de a solicita cât mai puţine date de la ascultătorii noştri. Radio Vestea Bună NU cere NICIODATĂ informaţii personale copiilor. Prin urmare copiilor nu li se cere adresa de email sau numele lor real atunci când fac descărcări de pe aplicaţie.\n\nRadio Vestea Bună este setat să se oprească atunci când vorbeşti la telefon, deci poţi vorbi fără să fi deranjat de radio în fundal. O dată terminată convorbirea telefonică, radioul va porni din nou.\nPoţi alege să primeşti notificări de la aplicaţia radio vestea bună. Pentru aceasta este nevoie sa bifezi da sau sa bifezi nu în caz că nu doreşti să primeşti notificări.\nAşa numitele fişiere „cookies” sunt mici fişiere text pe care browserul le stochează pe hard discul calculatorului (sau al altor dispozitive) atunci când navighezi pe Internet. Acestea nu fac niciun rău fişierelor din calculator (sau telefonului) şi nici nu pot citi informaţia din calculator. Ele însă permit site-urilor să „ţină minte” activitatea userilor pe Internet cât şi ce site-uri au vizitat aceştia. La Radio Vestea Bună folosim fişierele cookie pentru a determina numărul vizitatorilor aplicaţiei pe parcursul unei perioade prestabilite de timp.\n\nPoţi bloca stocarea acestor fişiere cookie pe hard discul calculatorului din meniul Unelte al browserului Internet Explorer/FireFox/Chrome.\nDe asemenea poţi şterge toate cookie-urile din telefonul sau dispozitivul de pe care asculţi radio, de la Setări.\nProprietarul şi Controlorul Datelor\nAMEC, Calea Turnisorului 90, 550048 Sibiu, Romania\nemail: amec.cef@gmail.com\n\nDeoarece instalarea de cookie-uri şi a altor sisteme de tracking în sistemul de servicii folosit de această aplicaţie nu poate fi controlată de Proprietar din punct de vedere tehnic, orice aspecte specifice legate de Cookies şi de sistemele de tracking instalate de terţi trebuie privite doar orientativ. Pentru a obţine date concrete, utilizatorul este rugat să consulte politica de confidenţialitate a terţilor menţionaţi în acest document.\n\nRadio Vestea Bună foloseşte Google Analytics\nServiciile din această secţiune îi dau posibilitatea Proprietarului să monitorizeze şi să analizeze traficul pe web şi poate urmări comportamentul unui user.\n\nGoogle Analytics (Google Inc.)\nGoogle Analytics este un serviciu de analiză web oferit de Google Inc. („Google“). Google foloseşte datele colectate pentru a urmări şi a examina modul în care este folosită această aplicaţie, cu scopul de a pregăti rapoarte despre activitatea sa şi de a le face disponibile şi altor servicii Google. Google poate folosi datele colectate şi pentru a contextualiza şi a personaliza reclamele reţelei proprii de publicitate.\nDate personale colectate: Cookies şi date de utilizare.\n\nAccesul părinţilor pe Radio Vestea Bună\nScopul nostru este acela de a oferi copiilor o alternativă sigură, folositoare şi distractivă de a petrece timpul. Părinţii sunt şi ei invitaţi să asculte Radio Vestea Bună şi să se convingă de faptul că Radio Vestea Bună  este locul unde copiii pot învăţa despre Dumnezeu şi pot să se distreze într-un mediu lipsit de pericole. Radio Vestea Bună poate face din când în când referire şi la alte pagini de Internet care au o practică difertă de colectare a informaţiei. Acele pagini sunt guvernate de propria lor politică de confidenţialitate care poate fi mult diferită de a noastră. Prin urmare, noi îi încurajăm pe vizitatorii paginii noastre de Internet să citeasca declaraţia de confidenţialitate a acelor pagini.\n\nÎntrebări/Nelămuriri?\nDacă aveţi întrebări, comentarii sau nelămuriri cu privire la politica de confidenţialitate a Radio Vestea Bună şi/sau la practicile noastre, vă rugăm să ne contactaţi folosind adresa pe care o găsiţi mai sus. În plus, pentru tine ca user, există posibilitatea să depui o plângere, pentru aceasta mergi la secţiunea Contact.\n')
            ],
          ),
        ),
      ),
    );
  }
}
