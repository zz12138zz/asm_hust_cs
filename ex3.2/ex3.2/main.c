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
	printf("请输入用户名：");
	scanf("%s", nameGet);
	printf("请输入密码：");
	scanf("%s", passwordGet);
	if (strcmp(nameGet, bossName) || strcmp(passwordGet, bossPassword)) {
		printf("用户名或密码错误！\n");
		return 0;
	}
	do {
		system("cls");
		printf("1.查找指定商品并显示其信息\n2.出货\n3.补货\n4.计算商品利润率\n5.按利润率从高到低显示商品的信息\n6.添加新商品\n9.退出\n请选择将要实现的功能：");
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
			printf("计算完毕\n");
			system("pause");
			break;
		}
		case 5: {
			if (sortAndDisplay(&LIST,GoodsInStorage) == 1) {
				printf("请先计算利润率！\n");
			}
			system("pause");
			break;
		}
		case 6: {
			if (GoodsInStorage < N) {
				printf("请输入商品名称：");
				scanf("%s", GA1[GoodsInStorage].GOODSNAME);
				printf("请输入进价：");
				scanf("%hd", &GA1[GoodsInStorage].BUYPRICE);
				printf("请输入售价：");
				scanf("%hd", &GA1[GoodsInStorage].SELLPRICE);
				printf("请输入进货量：");
				scanf("%hd", &GA1[GoodsInStorage].BUYNUM);
				printf("请输入出货量：");
				scanf("%hd", &GA1[GoodsInStorage].SELLNUM);
				GoodsInStorage++;
				printf("添加成功，仓库中现有%d种商品\n", GoodsInStorage);
			}
			else {
				printf("仓库已满，无法添加商品");
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