#pragma pack(1)
#define _CRT_SECURE_NO_WARNINGS 1
#define N 100
#include <stdio.h>
#include <string.h>
typedef struct GOODS
{
	char GOODSNAME[10];
	short BUYPRICE;
	short SELLPRICE;
	short BUYNUM;
	short SELLNUM;
	short RATE;
}GOODS;
int GoodsInStorage=30;
extern GOODS GA1[];
extern GOODS** LIST;
char* _stdcall searchGoods();
void _stdcall sellGoods(GOODS*,int);
void _stdcall buyGoods(GOODS*,int);
void _stdcall calculateRates(GOODS*, int, GOODS***);
int _stdcall sortAndDisplay(GOODS***,int);
const char bossName[] = "ZHENGZHOU";
const char bossPassword[] = "U201915115";
//short int x = 10;
//short int y = 20;
//void f(GOODS* p, int GoodsNum) {
//	for (int i = 0; i < GoodsNum; i++) {
//		p->RATE = (((p->SELLNUM * p->SELLPRICE) - (p->BUYNUM * p->BUYPRICE))*100) / (p->BUYNUM * p->BUYPRICE);
//		printf("%s %hd %hd %hd %hd %hd\n", p->GOODSNAME, p->BUYNUM, p->BUYPRICE, p->SELLNUM, p->SELLPRICE,p->RATE);
//		p++;
//	}
//}
int main() {
	//*(&x + 2) = 10;
	//int x=1;
	//int y = 2;	
	//printf("%d\n", x);
	//_asm {
	//	add ebp,4
	//}
	//printf("%d\n",x);
	//system("pause");
	char nameGet[20];
	char passwordGet[20];
	int choice;
	char goodsNameGet[10];
	printf("�������û�����");
	scanf("%s", nameGet);
	printf("���������룺");
	scanf("%s", passwordGet);
	if (strcmp(nameGet, bossName) || strcmp(passwordGet, bossPassword)) {
		printf("�û������������\n");
		return 0;
	}
	do {
		system("cls");
		printf("1.����ָ����Ʒ����ʾ����Ϣ\n2.����\n3.����\n4.������Ʒ������\n5.�������ʴӸߵ�����ʾ��Ʒ����Ϣ\n6.�������Ʒ\n9.�˳�\n��ѡ��Ҫʵ�ֵĹ��ܣ�");
		scanf("%d", &choice);
		switch (choice)
		{
		case 1: {
			searchGoods();
			break;
		}
		case 2: {
			sellGoods(GA1,GoodsInStorage);
			system("pause");
			break;
		}
		case 3: {
			buyGoods(GA1, GoodsInStorage);
			system("pause");
			break;
		}
		case 4: {
			calculateRates(GA1, GoodsInStorage, &LIST);
			printf("�������\n");
			system("pause");
			break;
		}
		case 5: {
			if (sortAndDisplay(&LIST,GoodsInStorage) == 1) {
				printf("���ȼ��������ʣ�\n");
			}
			system("pause");
			break;
		}
		case 6: {
			if (GoodsInStorage < N) {
				printf("��������Ʒ���ƣ�");
				scanf("%s", GA1[GoodsInStorage].GOODSNAME);
				printf("��������ۣ�");
				scanf("%hd", &GA1[GoodsInStorage].BUYPRICE);
				printf("�������ۼۣ�");
				scanf("%hd", &GA1[GoodsInStorage].SELLPRICE);
				printf("�������������");
				scanf("%hd", &GA1[GoodsInStorage].BUYNUM);
				printf("�������������");
				scanf("%hd", &GA1[GoodsInStorage].SELLNUM);
				GoodsInStorage++;
				printf("��ӳɹ����ֿ�������%d����Ʒ\n", GoodsInStorage);
			}
			else {
				printf("�ֿ��������޷������Ʒ");
			}
			system("pause");
			break;
		}
		//case 7:
		//	f(GA1,GoodsInStorage);
		//	system("pause");
		default:
			break;
		}
	} while (choice != 9);
	return 0;
}